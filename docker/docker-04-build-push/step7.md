# Шаг 7: Итоговое задание

Полный цикл: написать Dockerfile → собрать → тегировать → опубликовать в локальный реестр → скачать и запустить.

**1. Создайте новое приложение:**

```bash
mkdir -p /opt/finalapp && cd /opt/finalapp
```{{execute}}

```bash
cat > server.py << 'PYTHON'
import http.server, socketserver, os, json

PORT = 8090

class Handler(http.server.BaseHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.send_header("Content-type", "application/json")
        self.end_headers()
        data = {
            "status": "ok",
            "version": os.environ.get("APP_VERSION", "unknown"),
            "hostname": os.uname().nodename
        }
        self.wfile.write(json.dumps(data).encode())
    def log_message(self, *args):
        pass

print(f"Server running on :{PORT}")
with socketserver.TCPServer(("", PORT), Handler) as s:
    s.serve_forever()
PYTHON
```{{execute}}

**2. Напишите Dockerfile с multi-stage и всеми изученными инструкциями:**

```bash
cat > Dockerfile << 'DOCKERFILE'
FROM python:3.11-alpine AS base

ARG VERSION=1.0.0
ENV APP_VERSION=$VERSION

WORKDIR /app
COPY server.py .

EXPOSE 8090
CMD ["python", "server.py"]
DOCKERFILE
```{{execute}}

**3. Соберите образ с тегом версии и latest:**

```bash
docker build --build-arg VERSION=1.0.0 -t finalapp:1.0.0 .
docker tag finalapp:1.0.0 finalapp:latest
```{{execute}}

**4. Запустите и проверьте:**

```bash
docker run -d --name finalapp -p 8090:8090 finalapp:1.0.0
curl http://localhost:8090
```{{execute}}

**5. Опубликуйте в локальный реестр:**

```bash
docker tag finalapp:1.0.0 localhost:5000/finalapp:1.0.0
docker push localhost:5000/finalapp:1.0.0
curl http://localhost:5000/v2/_catalog
```{{execute}}

**6. Остановите, удалите локальный образ и восстановите из реестра:**

```bash
docker stop finalapp && docker rm finalapp
docker rmi finalapp:1.0.0 finalapp:latest
docker pull localhost:5000/finalapp:1.0.0
docker run --rm localhost:5000/finalapp:1.0.0 python -c "print('Restored from registry!')"
```{{execute}}
