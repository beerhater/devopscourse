# Шаг 2: Docker build и push в пайплайне

## Создаём приложение

```bash
cd /opt/gitlab-ci-2-demo
```{{execute}}

```bash
cat > app.py << 'PYEOF'
import http.server, socketserver, json, os, datetime

VERSION = os.environ.get("APP_VERSION", "dev")
BUILD_SHA = os.environ.get("CI_COMMIT_SHORT_SHA", "local")

class Handler(http.server.BaseHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.send_header("Content-type", "application/json")
        self.end_headers()
        self.wfile.write(json.dumps({
            "app": "gitlab-ci-demo",
            "version": VERSION,
            "build_sha": BUILD_SHA,
            "time": datetime.datetime.now().isoformat()
        }, indent=2).encode())
    def log_message(self, *args): pass

if __name__ == "__main__":
    with socketserver.TCPServer(("", 8080), Handler) as s:
        print(f"Server v{VERSION} on :8080")
        s.serve_forever()
PYEOF

cat > tests.py << 'PYEOF'
import sys; sys.path.insert(0, ".")

def test_imports():
    import app
    assert hasattr(app, "Handler")
    print("test_imports: OK")

def test_version_env():
    import os, importlib, app
    os.environ["APP_VERSION"] = "2.0.0"
    importlib.reload(app)
    assert app.VERSION == "2.0.0"
    print("test_version_env: OK")

if __name__ == "__main__":
    test_imports()
    test_version_env()
    print("Все тесты прошли!")
PYEOF

python3 tests.py
```{{execute}}

```bash
cat > Dockerfile << 'DFILE'
FROM python:3.11-alpine
ARG APP_VERSION=dev
ARG CI_COMMIT_SHORT_SHA=local
ENV APP_VERSION=$APP_VERSION
ENV CI_COMMIT_SHORT_SHA=$CI_COMMIT_SHORT_SHA
WORKDIR /app
COPY tests.py app.py ./
RUN python3 tests.py
EXPOSE 8080
CMD ["python3", "app.py"]
DFILE
```{{execute}}

## Полный pipeline с Docker build и push

```bash
cat > .gitlab-ci.yml << 'GLCI'
stages:
  - test
  - build
  - verify
  - deploy

variables:
  # В реальном GitLab эти переменные заполняются автоматически
  # Здесь мы определяем их явно для локального запуска
  APP_VERSION: "1.0.0"
  REGISTRY: "localhost:5000"
  IMAGE_NAME: "mygroup/gitlab-ci-demo"

  # Полный путь к образу — используем в каждом job
  IMAGE: "$REGISTRY/$IMAGE_NAME"

# ── Stage: test ───────────────────────────────────────────────
unit-tests:
  stage: test
  script:
    - echo "Запускаем тесты..."
    - python3 tests.py

# ── Stage: build ──────────────────────────────────────────────
docker-build:
  stage: build
  script:
    # Строим образ с двумя тегами: SHA коммита и latest
    - |
      docker build         --build-arg APP_VERSION=$APP_VERSION         --build-arg CI_COMMIT_SHORT_SHA=${CI_COMMIT_SHORT_SHA:-local}         -t $IMAGE:${CI_COMMIT_SHORT_SHA:-local}         -t $IMAGE:latest         .
    - echo "Образ собран: $IMAGE:${CI_COMMIT_SHORT_SHA:-local}"
    # Push в registry
    - docker push $IMAGE:${CI_COMMIT_SHORT_SHA:-local}
    - docker push $IMAGE:latest
    - echo "Образ запушен в registry!"
  after_script:
    - echo "docker-build завершён"

# ── Stage: verify ─────────────────────────────────────────────
# Проверяем что образ из registry работает корректно
smoke-test:
  stage: verify
  script:
    - echo "Скачиваем образ из registry..."
    - docker pull $IMAGE:latest
    - echo "Запускаем контейнер для проверки..."
    - docker run --rm $IMAGE:latest python3 tests.py
    - echo "Smoke test прошёл!"

# ── Stage: deploy ─────────────────────────────────────────────
deploy-staging:
  stage: deploy
  script:
    - echo "Останавливаем старый контейнер..."
    - docker stop staging-app 2>/dev/null || true
    - docker rm staging-app 2>/dev/null || true
    - echo "Запускаем новый контейнер из registry..."
    - |
      docker run -d         --name staging-app         -p 8080:8080         $IMAGE:latest
    - sleep 2
    - echo "Проверяем что сервер отвечает..."
    - curl -sf http://localhost:8080 | python3 -m json.tool
    - echo "Деплой на staging успешен!"
  after_script:
    - docker stop staging-app 2>/dev/null || true
    - docker rm staging-app 2>/dev/null || true
GLCI
```{{execute}}

## Запускаем через gitlab-runner

```bash
python3 -c "import yaml; yaml.safe_load(open('.gitlab-ci.yml')); print('YAML OK')"
```{{execute}}

```bash
echo "=== Job: unit-tests ===" && gitlab-runner exec shell unit-tests 2>&1 | tail -15
```{{execute}}

```bash
echo "=== Job: docker-build ===" && gitlab-runner exec shell docker-build 2>&1 | tail -20
```{{execute}}

```bash
echo "=== Job: smoke-test ===" && gitlab-runner exec shell smoke-test 2>&1 | tail -15
```{{execute}}

```bash
echo "=== Job: deploy-staging ===" && gitlab-runner exec shell deploy-staging 2>&1 | tail -20
```{{execute}}

```bash
# Проверяем что образ действительно есть в registry
curl -s http://localhost:5000/v2/mygroup/gitlab-ci-demo/tags/list | python3 -m json.tool
```{{execute}}
