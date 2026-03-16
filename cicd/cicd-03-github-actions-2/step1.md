# Шаг 1: Docker в CI/CD — зачем и как

## Почему Docker + CI/CD = идеальная пара

Вспомним проблему из первого модуля: "у меня работает, а на сервере нет". Docker решает её — образ содержит **всё что нужно для запуска**: код, зависимости, нужную версию Python/Node/Go.

CI/CD делает сборку образа **автоматической и воспроизводимой**:
- Каждый коммит → новый образ
- Образ тегируется номером коммита → можно откатиться к любой версии
- Сборка всегда в одинаковом окружении → нет "у меня работает"

## Типичный Docker CI/CD Flow

```bash
cat > /opt/docker-flow.txt << 'EOF'
ПОЛНЫЙ DOCKER CI/CD FLOW
========================

1. git push origin main
   │
2. GitHub Actions запускается
   │
3. job: test
   ├── git checkout
   ├── pip install -r requirements.txt
   └── pytest tests/
   │
   (если тесты прошли)
   │
4. job: build-and-push
   ├── docker login (через секреты)
   ├── docker build -t username/app:SHA .
   ├── docker build -t username/app:latest .
   └── docker push username/app:SHA
       docker push username/app:latest
   │
5. Образ доступен в Docker Hub
   │
6. (опционально) job: deploy
   └── ssh server "docker pull username/app:latest && docker-compose up -d"

РЕЗУЛЬТАТ:
  - username/app:latest    — всегда последняя версия
  - username/app:abc1234   — версия конкретного коммита
  - username/app:v1.2.3    — версия конкретного релиза
EOF
cat /opt/docker-flow.txt
```{{execute}}

## Создайте учебное приложение

```bash
mkdir -p /opt/docker-actions-demo/.github/workflows
cd /opt/docker-actions-demo
```{{execute}}

```bash
cat > app.py << 'PYEOF'
import http.server
import socketserver
import os
import json
import datetime

class Handler(http.server.BaseHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.send_header("Content-type", "application/json")
        self.end_headers()
        response = {
            "app": "docker-actions-demo",
            "version": os.environ.get("APP_VERSION", "dev"),
            "build_sha": os.environ.get("BUILD_SHA", "unknown"),
            "time": datetime.datetime.now().isoformat(),
            "message": "Built by GitHub Actions!"
        }
        self.wfile.write(json.dumps(response, indent=2).encode())

    def log_message(self, *args):
        pass  # Отключаем лишние логи

if __name__ == "__main__":
    port = int(os.environ.get("PORT", 8080))
    with socketserver.TCPServer(("", port), Handler) as httpd:
        print(f"Server running on port {port}")
        httpd.serve_forever()
PYEOF
```{{execute}}

```bash
cat > tests.py << 'PYEOF'
import sys
import os
sys.path.insert(0, ".")

def test_app_imports():
    import app
    print("test_app_imports: OK")

def test_handler_exists():
    from app import Handler
    assert hasattr(Handler, "do_GET")
    print("test_handler_exists: OK")

def test_env_variable():
    os.environ["APP_VERSION"] = "1.0.0"
    assert os.environ.get("APP_VERSION") == "1.0.0"
    print("test_env_variable: OK")

if __name__ == "__main__":
    test_app_imports()
    test_handler_exists()
    test_env_variable()
    print("Все тесты прошли!")
PYEOF
```{{execute}}

```bash
python3 tests.py
```{{execute}}

```bash
cat > requirements.txt << 'EOF'
# Приложение использует только стандартную библиотеку Python
# В реальных проектах здесь были бы: flask, fastapi, requests и т.д.
EOF
```{{execute}}
