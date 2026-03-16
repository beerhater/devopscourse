# Шаг 7: Итоговое задание

Развернём трёхзвенную архитектуру: nginx (frontend) → Python-приложение (backend) → Redis (cache).

**1. Создайте изолированные сети:**

```bash
docker network create frontend
docker network create backend
```{{execute}}

**2. Запустите Redis только во внутренней сети:**

```bash
docker run -d --name redis-cache --network backend redis:alpine
```{{execute}}

**3. Создайте backend-приложение:**

```bash
mkdir -p /opt/webapp && cat > /opt/webapp/app.py << 'PYTHON'
import http.server, socketserver, urllib.request, os

class Handler(http.server.BaseHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.end_headers()
        self.wfile.write(b"Backend OK! Redis reachable via internal network.\n")
    def log_message(self, *args): pass

with socketserver.TCPServer(("", 5000), Handler) as s:
    print("Backend on :5000")
    s.serve_forever()
PYTHON
```{{execute}}

```bash
cat > /opt/webapp/Dockerfile << 'DOCKERFILE'
FROM python:3.11-alpine
WORKDIR /app
COPY app.py .
EXPOSE 5000
CMD ["python", "app.py"]
DOCKERFILE
docker build -t my-backend /opt/webapp
```{{execute}}

**4. Запустите backend в обеих сетях:**

```bash
docker run -d --name backend-app --network backend my-backend
docker network connect frontend backend-app
```{{execute}}

**5. Запустите nginx как reverse proxy во frontend:**

```bash
docker run -d --name frontend-nginx \
  --network frontend \
  -p 8080:80 \
  nginx:alpine
```{{execute}}

**6. Проверьте связь по сети:**

```bash
# backend видит redis по имени
docker exec backend-app ping -c 2 redis-cache

# nginx видит backend по имени
docker exec frontend-nginx wget -qO- http://backend-app:5000
```{{execute}}

**7. nginx НЕ должен видеть redis (изоляция):**

```bash
docker exec frontend-nginx ping -c 1 redis-cache || echo "Изоляция работает!"
```{{execute}}

**8. Очистите всё:**

```bash
docker stop frontend-nginx backend-app redis-cache
docker rm frontend-nginx backend-app redis-cache
docker network rm frontend backend
docker network prune -f
```{{execute}}
