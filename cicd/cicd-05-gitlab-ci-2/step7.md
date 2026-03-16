# Шаг 7: Итоговое задание — полный GitLab CI/CD

Соберите всё изученное в один профессиональный пайплайн.

## 1. Создайте проект

```bash
mkdir -p /opt/final-gitlab-ci-2/{ci,.gitlab}
cd /opt/final-gitlab-ci-2
```{{execute}}

## 2. Flask-приложение `app.py`

```bash
cat > app.py << 'PYEOF'
import http.server, socketserver, json, os, datetime

VERSION = os.environ.get("APP_VERSION", "dev")
SHA     = os.environ.get("CI_COMMIT_SHORT_SHA", "local")

class Handler(http.server.BaseHTTPRequestHandler):
    def do_GET(self):
        routes = {
            "/":        {"app": "final-app", "version": VERSION, "sha": SHA},
            "/health":  {"status": "ok"},
            "/metrics": {"requests_total": 42, "uptime_seconds": 3600},
        }
        body = routes.get(self.path, {"error": "not found"})
        code = 200 if self.path in routes else 404
        self.send_response(code)
        self.send_header("Content-type", "application/json")
        self.end_headers()
        self.wfile.write(json.dumps(body, indent=2).encode())
    def log_message(self, *args): pass

if __name__ == "__main__":
    with socketserver.TCPServer(("", 8080), Handler) as s:
        print(f"Final App v{VERSION} ({SHA}) on :8080")
        s.serve_forever()
PYEOF
```{{execute}}

```bash
cat > tests.py << 'PYEOF'
import sys; sys.path.insert(0, ".")
import app

def test_routes_exist():
    h = app.Handler
    assert hasattr(h, "do_GET")
    print("test_routes_exist: OK")

def test_version_default():
    import os
    os.environ.pop("APP_VERSION", None)
    import importlib; importlib.reload(app)
    assert app.VERSION == "dev"
    print("test_version_default: OK")

def test_version_env():
    import os, importlib
    os.environ["APP_VERSION"] = "2.0.0"
    importlib.reload(app)
    assert app.VERSION == "2.0.0"
    print("test_version_env: OK")

if __name__ == "__main__":
    test_routes_exist()
    test_version_default()
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
COPY app.py tests.py ./
RUN python3 tests.py
EXPOSE 8080
CMD ["python3", "app.py"]
DFILE
```{{execute}}

## 3. Разбейте конфиг на файлы

```bash
cat > ci/lint.yml << 'GLCI'
syntax-check:
  stage: lint
  script:
    - python3 -m py_compile app.py tests.py
    - echo "Синтаксис OK"
GLCI
```{{execute}}

```bash
cat > ci/test.yml << 'GLCI'
.base-test:
  stage: test
  before_script:
    - echo "=== $CI_JOB_NAME ==="
  after_script:
    - echo "Тест завершён: $CI_JOB_NAME"

unit-tests:
  extends: .base-test
  script:
    - python3 tests.py
  rules:
    - when: on_success
GLCI
```{{execute}}

```bash
cat > ci/docker.yml << 'GLCI'
.docker-base:
  stage: build
  before_script:
    - echo "Начинаем сборку образа..."

docker-build:
  extends: .docker-base
  script:
    - |
      docker build         --build-arg APP_VERSION=${APP_VERSION:-1.0.0}         --build-arg CI_COMMIT_SHORT_SHA=${CI_COMMIT_SHORT_SHA:-local}         -t ${REGISTRY:-localhost:5000}/final-app:${CI_COMMIT_SHORT_SHA:-local}         -t ${REGISTRY:-localhost:5000}/final-app:latest         .
    - docker push ${REGISTRY:-localhost:5000}/final-app:latest
    - echo "Образ запушен!"
  rules:
    - changes: [Dockerfile, app.py, requirements.txt]
      when: on_success
    - when: on_success
GLCI
```{{execute}}

```bash
cat > ci/deploy.yml << 'GLCI'
.deploy-base:
  stage: deploy
  before_script:
    - echo "Деплой на $DEPLOY_ENV..."
  after_script:
    - docker stop final-app-$DEPLOY_ENV 2>/dev/null || true
    - docker rm final-app-$DEPLOY_ENV 2>/dev/null || true

deploy-staging:
  extends: .deploy-base
  variables:
    DEPLOY_ENV: "staging"
  script:
    - docker run -d --name final-app-$DEPLOY_ENV         ${REGISTRY:-localhost:5000}/final-app:latest
    - sleep 1
    - docker logs final-app-$DEPLOY_ENV 2>&1 | head -3
    - echo "Staging OK!"
  environment:
    name: staging
    url: http://staging.example.com
  rules:
    - if: '$CI_COMMIT_BRANCH == "main"'
      when: on_success
    - when: never
GLCI
```{{execute}}

## 4. Главный `.gitlab-ci.yml`

```bash
cat > .gitlab-ci.yml << 'GLCI'
stages:
  - lint
  - test
  - build
  - deploy

variables:
  APP_VERSION: "1.0.0"
  REGISTRY: "localhost:5000"

include:
  - local: "ci/lint.yml"
  - local: "ci/test.yml"
  - local: "ci/docker.yml"
  - local: "ci/deploy.yml"
GLCI
```{{execute}}

## 5. Проверьте и запустите

```bash
python3 -c "
import yaml, os
files = ['.gitlab-ci.yml','ci/lint.yml','ci/test.yml','ci/docker.yml','ci/deploy.yml']
for f in files:
    try:
        yaml.safe_load(open(f))
        print(f'OK  {f}')
    except Exception as e:
        print(f'ERR {f}: {e}')
"
```{{execute}}

```bash
for job in syntax-check unit-tests docker-build deploy-staging; do
  echo ""
  echo "════════════════════════════════"
  echo "=== Job: $job ==="
  echo "════════════════════════════════"
  gitlab-runner exec shell $job     --env CI_COMMIT_SHORT_SHA=abc12345     --env CI_COMMIT_BRANCH=main 2>&1 | tail -12
done
```{{execute}}

```bash
# Финальная проверка: образ в registry + verify что extends работает
curl -s http://localhost:5000/v2/final-app/tags/list | python3 -m json.tool
echo ""
grep -c "extends:" ci/test.yml ci/deploy.yml && echo "extends: используется!"
```{{execute}}
