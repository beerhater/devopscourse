# Шаг 7: Итоговое задание

Создайте полноценный образ с простым веб-сервером на Python.

**1. Создайте рабочую директорию и файлы приложения:**

```bash
mkdir -p /opt/webapp && cd /opt/webapp
```{{execute}}

```bash
cat > app.py << 'PYTHON'
import http.server
import socketserver
import os

PORT = int(os.environ.get("PORT", 8080))

class Handler(http.server.SimpleHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.end_headers()
        msg = f"Hello from Docker! Version: {os.environ.get('APP_VERSION', 'unknown')}\n"
        self.wfile.write(msg.encode())

with socketserver.TCPServer(("", PORT), Handler) as httpd:
    print(f"Serving on port {PORT}")
    httpd.serve_forever()
PYTHON
```{{execute}}

**2. Создайте `.dockerignore`:**

```bash
echo -e "*.pyc\n__pycache__\n.git" > .dockerignore
```{{execute}}

**3. Напишите Dockerfile, используя все изученные инструкции:**

```bash
cat > Dockerfile << 'DOCKERFILE'
FROM python:3.11-alpine

ARG VERSION=1.0.0

ENV APP_VERSION=$VERSION \
    PORT=8080

WORKDIR /app

COPY app.py .

EXPOSE 8080

CMD ["python", "app.py"]
DOCKERFILE
```{{execute}}

**4. Соберите образ:**

```bash
docker build --build-arg VERSION=1.0.0 -t my-webapp:1.0 .
```{{execute}}

**5. Запустите контейнер:**

```bash
docker run -d --name webapp -p 8080:8080 my-webapp:1.0
```{{execute}}

**6. Проверьте работу:**

```bash
curl http://localhost:8080
```{{execute}}

**7. Посмотрите слои образа:**

```bash
docker history my-webapp:1.0
```{{execute}}

**8. Остановите и удалите:**

```bash
docker stop webapp && docker rm webapp
```{{execute}}
