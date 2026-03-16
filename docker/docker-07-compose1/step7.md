# Шаг 7: Итоговое задание

Опишите и запустите стек: Python-бекенд + PostgreSQL + Redis + nginx.

**1. Создайте директорию:**

```bash
mkdir -p /opt/fullstack/app && cd /opt/fullstack
```{{execute}}

**2. Создайте приложение:**

```bash
cat > app/main.py << 'PYFILE'
import http.server, socketserver, os, json

class Handler(http.server.BaseHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.send_header("Content-type", "application/json")
        self.end_headers()
        self.wfile.write(json.dumps({
            "env":   os.environ.get("APP_ENV", "unknown"),
            "db":    os.environ.get("DB_HOST", "unknown"),
            "cache": os.environ.get("CACHE_HOST", "unknown")
        }, indent=2).encode())
    def log_message(self, *args): pass

with socketserver.TCPServer(("", 5000), Handler) as s:
    print("Backend on :5000"); s.serve_forever()
PYFILE
```{{execute}}

```bash
cat > app/Dockerfile << 'DFILE'
FROM python:3.11-alpine
WORKDIR /app
COPY main.py .
EXPOSE 5000
CMD ["python", "main.py"]
DFILE
```{{execute}}

**3. Создайте .env:**

```bash
cat > .env << 'ENVFILE'
APP_ENV=production
DB_PASSWORD=secret123
ENVFILE
```{{execute}}

**4. Напишите docker-compose.yml:**

```bash
cat > docker-compose.yml << 'COMPOSEFILE'
services:
  backend:
    build: ./app
    environment:
      APP_ENV: ${APP_ENV}
      DB_HOST: postgres
      CACHE_HOST: redis
    networks:
      - internal
    depends_on:
      - postgres
      - redis

  postgres:
    image: postgres:15-alpine
    environment:
      POSTGRES_PASSWORD: ${DB_PASSWORD}
    volumes:
      - pg-data:/var/lib/postgresql/data
    networks:
      - internal

  redis:
    image: redis:alpine
    networks:
      - internal

  nginx:
    image: nginx:alpine
    ports:
      - "8080:80"
    networks:
      - internal
    depends_on:
      - backend

networks:
  internal:

volumes:
  pg-data:
COMPOSEFILE
```{{execute}}

**5. Запустите:**

```bash
docker-compose up -d --build
```{{execute}}

**6. Проверьте сервисы:**

```bash
docker-compose ps
```{{execute}}

**7. Проверьте бекенд:**

```bash
docker-compose exec nginx wget -qO- http://backend:5000
```{{execute}}

**8. Логи:**

```bash
docker-compose logs --tail=5
```{{execute}}

**9. Очистите:**

```bash
docker-compose down -v
```{{execute}}
