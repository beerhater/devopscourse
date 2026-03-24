# Шаг 3: build в Compose

Вместо готового образа Compose может **собрать образ** из Dockerfile прямо при запуске.

## Синтаксис build

```yaml
# Краткая форма
build: ./app

# Расширенная форма
build:
  context: ./app
  dockerfile: Dockerfile.prod
  args:
    VERSION: 1.0.0
  target: production
```

## Задание: приложение с build

```bash
cd /opt/compose2 && mkdir -p app
```{{execute}}

```bash
cat > app/server.py << 'PYFILE'
import http.server, socketserver, os, json, datetime

class Handler(http.server.BaseHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.send_header("Content-type", "application/json")
        self.end_headers()
        self.wfile.write(json.dumps({
            "version": os.environ.get("APP_VERSION", "dev"),
            "time": datetime.datetime.now().isoformat(),
        }, indent=2).encode())
    def log_message(self, *args): pass

with socketserver.TCPServer(("", 5000), Handler) as s:
    print("Server on :5000"); s.serve_forever()
PYFILE
```{{execute}}

```bash
cat > app/Dockerfile << 'DFILE'
FROM python:3.11-alpine
ARG APP_VERSION=dev
ENV APP_VERSION=$APP_VERSION
WORKDIR /app
COPY server.py .
EXPOSE 5000
CMD ["python", "server.py"]
DFILE
```{{execute}}

```bash
cat > docker-compose.yml << 'COMPOSEFILE'
services:
  app:
    build:
      context: ./app
      args:
        APP_VERSION: "2.0.0"
    ports:
      - "5000:5000"

  redis:
    image: redis:alpine
COMPOSEFILE
```{{execute}}

```bash
docker compose up -d --build
curl http://localhost:5000
```{{execute}}

`--build` принудительно пересобирает образы при каждом `up`.

```bash
docker compose down
```{{execute}}
