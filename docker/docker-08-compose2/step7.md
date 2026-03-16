# Шаг 7: Итоговое задание

Соберите production-ready стек со всеми изученными возможностями.

**1. Подготовьте директорию:**

```bash
mkdir -p /opt/prod-stack/app && cd /opt/prod-stack
```{{execute}}

**2. Создайте приложение:**

```bash
cat > app/server.py << 'PYFILE'
import http.server, socketserver, os, json

COUNTER = 0

class Handler(http.server.BaseHTTPRequestHandler):
    def do_GET(self):
        global COUNTER
        COUNTER += 1
        self.send_response(200)
        self.send_header("Content-type", "application/json")
        self.end_headers()
        self.wfile.write(json.dumps({
            "env": os.environ.get("APP_ENV", "unknown"),
            "version": os.environ.get("APP_VERSION", "dev"),
            "requests": COUNTER,
            "instance": os.uname().nodename,
        }, indent=2).encode())
    def log_message(self, *args): pass

with socketserver.TCPServer(("", 5000), Handler) as s:
    print("Ready"); s.serve_forever()
PYFILE
```{{execute}}

```bash
cat > app/Dockerfile << 'DFILE'
FROM python:3.11-alpine
ARG APP_VERSION=dev
ENV APP_VERSION=$APP_VERSION
WORKDIR /app
COPY server.py .
HEALTHCHECK --interval=10s --timeout=3s --retries=3 CMD wget -qO- http://localhost:5000 || exit 1
EXPOSE 5000
CMD ["python", "server.py"]
DFILE
```{{execute}}

**3. .env файл:**

```bash
cat > .env << 'ENVFILE'
APP_ENV=production
APP_VERSION=1.0.0
DB_PASSWORD=strongpassword
ENVFILE
```{{execute}}

**4. docker-compose.yml:**

```bash
cat > docker-compose.yml << 'COMPOSEFILE'
services:
  app:
    build:
      context: ./app
      args:
        APP_VERSION: ${APP_VERSION}
    environment:
      APP_ENV: ${APP_ENV}
    expose:
      - "5000"
    restart: unless-stopped
    healthcheck:
      test: ["CMD", "wget", "-qO-", "http://localhost:5000"]
      interval: 10s
      timeout: 5s
      retries: 3
      start_period: 5s
    depends_on:
      db:
        condition: service_healthy
      redis:
        condition: service_healthy

  db:
    image: postgres:15-alpine
    environment:
      POSTGRES_PASSWORD: ${DB_PASSWORD}
    volumes:
      - db-data:/var/lib/postgresql/data
    restart: unless-stopped
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U postgres"]
      interval: 10s
      timeout: 5s
      retries: 5
      start_period: 10s

  redis:
    image: redis:alpine
    restart: unless-stopped
    healthcheck:
      test: ["CMD", "redis-cli", "ping"]
      interval: 10s
      timeout: 3s
      retries: 3

  nginx:
    image: nginx:alpine
    ports:
      - "8080:80"
    restart: unless-stopped
    depends_on:
      app:
        condition: service_healthy

  adminer:
    image: adminer
    ports:
      - "8081:8080"
    profiles: ["dev"]
    depends_on:
      - db

volumes:
  db-data:
COMPOSEFILE
```{{execute}}

**5. Запустите:**

```bash
docker-compose up -d --build
```{{execute}}

**6. Следите за healthcheck:**

```bash
watch -n 3 docker-compose ps
```{{execute}}

Дождитесь `healthy` у всех сервисов, затем Ctrl+C.

**7. Запустите 3 реплики app:**

```bash
docker-compose up -d --scale app=3
docker-compose ps
```{{execute}}

**8. Проверьте nginx:**

```bash
curl http://localhost:8080
```{{execute}}

**9. Dev-профиль:**

```bash
docker-compose --profile dev up -d
docker-compose ps
```{{execute}}

**10. Очистите:**

```bash
docker-compose --profile dev down -v
```{{execute}}
