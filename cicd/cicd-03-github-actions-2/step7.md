# Шаг 7: Итоговое задание

Создайте полный CI/CD пайплайн для нового приложения самостоятельно.

## 1. Создайте проект

```bash
mkdir -p /opt/final-docker-actions/.github/workflows
cd /opt/final-docker-actions
git init
git config user.email "student@devops.local"
git config user.name "Student"
```{{execute}}

## 2. Приложение `server.py`

```bash
cat > server.py << 'PYEOF'
import http.server
import socketserver
import json
import os
import datetime

VERSION = os.environ.get("APP_VERSION", "dev")

class Handler(http.server.BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path == "/health":
            self.send_response(200)
            self.send_header("Content-type", "application/json")
            self.end_headers()
            self.wfile.write(json.dumps({"status": "ok"}).encode())
        else:
            self.send_response(200)
            self.send_header("Content-type", "application/json")
            self.end_headers()
            self.wfile.write(json.dumps({
                "app": "my-final-app",
                "version": VERSION,
                "time": datetime.datetime.now().isoformat()
            }, indent=2).encode())

    def log_message(self, *args): pass

if __name__ == "__main__":
    with socketserver.TCPServer(("", 8080), Handler) as s:
        print(f"Server v{VERSION} on :8080")
        s.serve_forever()
PYEOF
```{{execute}}

## 3. Тесты `tests.py`

```bash
cat > tests.py << 'PYEOF'
import sys
sys.path.insert(0, ".")

def test_server_imports():
    import server
    assert hasattr(server, "Handler")
    print("test_server_imports: OK")

def test_version_env():
    import os
    os.environ["APP_VERSION"] = "2.0.0"
    import importlib
    import server
    importlib.reload(server)
    assert server.VERSION == "2.0.0"
    print("test_version_env: OK")

def test_handler_has_health():
    from server import Handler
    import inspect
    assert "do_GET" in dir(Handler)
    print("test_handler_has_health: OK")

if __name__ == "__main__":
    test_server_imports()
    test_version_env()
    test_handler_has_health()
    print("Все тесты прошли!")
PYEOF
python3 tests.py
```{{execute}}

## 4. Dockerfile

```bash
cat > Dockerfile << 'DFILE'
FROM python:3.11-alpine
ARG APP_VERSION=dev
ENV APP_VERSION=$APP_VERSION
WORKDIR /app
COPY tests.py server.py .
RUN python3 tests.py
EXPOSE 8080
CMD ["python3", "server.py"]
DFILE
```{{execute}}

## 5. Напишите workflow `.github/workflows/ci-cd.yml`

Требования:
- Триггеры: `push` в main + `pull_request` в main
- Job `test`: запуск `python3 tests.py` на Python 3.10 и 3.11 через **matrix**
- Job `build`: собирает Docker-образ `my-final-app:latest`, ждёт `test`
  - `cache-from: type=gha`, `cache-to: type=gha,mode=max`
  - `build-args: APP_VERSION=${{ github.sha }}`
  - `load: true` (для локальной проверки)
- Job `verify`: запускает `python3 tests.py` внутри собранного контейнера

```bash
cat > .github/workflows/ci-cd.yml << 'WORKFLOW'
name: CI/CD Final

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  test:
    name: "Test Python ${{ matrix.python-version }}"
    runs-on: ubuntu-latest
    strategy:
      matrix:
        python-version: ["3.10", "3.11"]
      fail-fast: false
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-python@v5
        with:
          python-version: ${{ matrix.python-version }}
      - run: python3 tests.py

  build:
    name: "Build Docker Image"
    runs-on: ubuntu-latest
    needs: test
    steps:
      - uses: actions/checkout@v4
      - uses: docker/setup-buildx-action@v3
      - name: Build image
        uses: docker/build-push-action@v5
        with:
          context: .
          push: false
          load: true
          tags: my-final-app:latest
          build-args: APP_VERSION=${{ github.sha }}
          cache-from: type=gha
          cache-to: type=gha,mode=max

  verify:
    name: "Verify Container"
    runs-on: ubuntu-latest
    needs: build
    steps:
      - uses: actions/checkout@v4
      - uses: docker/setup-buildx-action@v3
      - name: Rebuild for verify
        uses: docker/build-push-action@v5
        with:
          context: .
          push: false
          load: true
          tags: my-final-app:latest
          build-args: APP_VERSION=${{ github.sha }}
          cache-from: type=gha
      - name: Run tests in container
        run: docker run --rm my-final-app:latest python3 tests.py
      - name: Check app starts
        run: |
          docker run -d --name verify-app -p 8080:8080 my-final-app:latest
          sleep 2
          curl -f http://localhost:8080/health
          docker stop verify-app && docker rm verify-app
WORKFLOW
```{{execute}}

## 6. Проверьте и запустите

```bash
python3 -c "import yaml; yaml.safe_load(open('.github/workflows/ci-cd.yml')); print('YAML OK')"
git add . && git commit -m "Final Docker Actions project"
```{{execute}}

```bash
act push -W .github/workflows/ci-cd.yml   --pull=false   -P ubuntu-latest=catthehacker/ubuntu:act-latest 2>&1 | tail -30
```{{execute}}
