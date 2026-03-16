# Шаг 1: Проблема Recreate-деплоя

## Собираем приложение для экспериментов

```bash
mkdir -p /opt/deploy-demo && cd /opt/deploy-demo
```{{execute}}

```bash
cat > app.py << 'PYEOF'
import http.server, socketserver, json, os, time, datetime
VERSION = os.environ.get("APP_VERSION", "v1.0.0")
COLOR   = os.environ.get("APP_COLOR", "blue")
PORT    = int(os.environ.get("APP_PORT", "8080"))
START   = time.time()
class Handler(http.server.BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path == "/health":
            body, code = {"status": "ok", "version": VERSION}, 200
        elif self.path == "/info":
            body, code = {"version": VERSION, "color": COLOR,
                "uptime": round(time.time() - START, 1),
                "time": datetime.datetime.now().isoformat(), "pid": os.getpid()}, 200
        else:
            body, code = {"app": "deploy-demo", "version": VERSION, "color": COLOR}, 200
        self.send_response(code)
        self.send_header("Content-type", "application/json")
        self.end_headers()
        self.wfile.write(json.dumps(body, indent=2).encode())
    def log_message(self, *a): pass
if __name__ == "__main__":
    print(f"Starting {VERSION} ({COLOR}) on :{PORT}", flush=True)
    with socketserver.TCPServer(("", PORT), Handler) as s:
        s.serve_forever()
PYEOF
```{{execute}}

```bash
cat > Dockerfile << 'EOF'
FROM python:3.11-alpine
ARG APP_VERSION=v1.0.0
ARG APP_COLOR=blue
ENV APP_VERSION=$APP_VERSION APP_COLOR=$APP_COLOR
WORKDIR /app
COPY app.py .
EXPOSE 8080
CMD ["python3", "app.py"]
EOF
docker build --build-arg APP_VERSION=v1.0.0 --build-arg APP_COLOR=blue  -t myapp:v1 . -q
docker build --build-arg APP_VERSION=v2.0.0 --build-arg APP_COLOR=green -t myapp:v2 . -q
echo "Образы собраны:"; docker images myapp
```{{execute}}

## Recreate: видим downtime

```bash
# Запускаем v1, затем деплоим v2 через Recreate
docker stop myapp 2>/dev/null; docker rm myapp 2>/dev/null || true
docker run -d --name myapp -p 8080:8080 myapp:v1 > /dev/null
sleep 2
echo "Версия до деплоя:"
curl -sf http://localhost:8080/info | python3 -m json.tool
```{{execute}}

```bash
echo "=== RECREATE DEPLOY ==="
echo "1. Останавливаем v1..."
docker stop myapp && docker rm myapp
echo "   *** DOWNTIME: сервис недоступен! ***"
sleep 3
echo "2. Запускаем v2..."
docker run -d --name myapp -p 8080:8080 myapp:v2 > /dev/null
sleep 2
echo "   Downtime закончился."
curl -sf http://localhost:8080/info | python3 -m json.tool
```{{execute}}

```bash
docker stop myapp 2>/dev/null; docker rm myapp 2>/dev/null || true
echo "Вывод: в реальном проде за эти ~5 секунд сотни запросов получат ошибку 'Connection refused'."
```{{execute}}
