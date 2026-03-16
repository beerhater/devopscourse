# Шаг 6: Smoke-тесты и автоматический откат

## Концепция

После каждого деплоя пайплайн автоматически проверяет работоспособность:

```
ДЕПЛОЙ С АВТО-ОТКАТОМ:
  1. Деплоим новую версию
  2. Ждём старта (sleep N)
  3. Smoke-тесты: /health, /info, латентность < 1с
  4а. Всё OK → деплой завершён ✓
  4б. Что-то упало → авто-откат на предыдущую версию
```

```bash
cd /opt/deploy-demo
```{{execute}}

```bash
cat > smoke-test.sh << 'BASH'
#!/bin/bash
HOST=${1:-localhost}; PORT=${2:-8080}; BASE="http://$HOST:$PORT"; FAILED=0

check() {
    code=$(curl -sf -o /dev/null -w "%{http_code}" --max-time 3 "$BASE$1" 2>/dev/null || echo "000")
    [ "$code" = "${2:-200}" ] && echo "  OK   $1 ($code)" || { echo "  FAIL $1 (ожидали ${2:-200}, получили $code)"; FAILED=$((FAILED+1)); }
}

check_ms() {
    ms=$(curl -sf -o /dev/null -w "%{time_total}" "$BASE$1" 2>/dev/null | python3 -c "import sys; print(int(float(sys.stdin.read())*1000))" 2>/dev/null || echo "9999")
    [ "$ms" -lt "${2:-2000}" ] && echo "  OK   $1 латентность: ${ms}мс" || { echo "  FAIL $1 латентность: ${ms}мс (>${2:-2000}мс)"; FAILED=$((FAILED+1)); }
}

echo "=== Smoke Tests: $BASE ==="
check /health; check /; check /info; check_ms /health 1000
echo ""
[ $FAILED -eq 0 ] && echo "PASSED ✓" && exit 0 || { echo "FAILED: $FAILED тестов"; exit 1; }
BASH
chmod +x smoke-test.sh
```{{execute}}

```bash
cat > deploy-with-rollback.sh << 'BASH'
#!/bin/bash
NEW=${1:-v2}; OLD=${2:-v1}; PORT=8088

redeploy() {
    docker stop myapp-prod 2>/dev/null; docker rm myapp-prod 2>/dev/null || true
    docker run -d --name myapp-prod -p $PORT:8080 myapp:$1 > /dev/null; sleep 2
}

echo "=== ДЕПЛОЙ С АВТО-ОТКАТОМ: $NEW (fallback: $OLD) ==="
echo ""; echo "1. Деплоим $NEW..."
redeploy $NEW

echo ""; echo "2. Smoke-тесты..."
if ./smoke-test.sh localhost $PORT; then
    VER=$(curl -sf http://localhost:$PORT/info | python3 -c "import sys,json; print(json.load(sys.stdin)['version'])" 2>/dev/null)
    echo ""; echo "✓ ДЕПЛОЙ УСПЕШЕН! В проде: $VER"
else
    echo ""; echo "✗ ТЕСТЫ НЕ ПРОШЛИ → авто-откат на $OLD..."
    redeploy $OLD
    ./smoke-test.sh localhost $PORT && echo "✓ Откат успешен: $OLD" || { echo "✗ КРИТИЧНО: откат тоже упал!"; exit 2; }
    exit 1
fi
BASH
chmod +x deploy-with-rollback.sh
```{{execute}}

```bash
./deploy-with-rollback.sh v2 v1
```{{execute}}

```bash
# Собираем заведомо сломанный образ (всегда отвечает 503)
cat > /tmp/app_broken.py << 'PYEOF'
import http.server, socketserver, os
PORT = int(os.environ.get("APP_PORT", "8080"))
class H(http.server.BaseHTTPRequestHandler):
    def do_GET(self):
        self.send_response(503); self.send_header("Content-type","text/plain"); self.end_headers()
        self.wfile.write(b"Service Unavailable")
    def log_message(self, *a): pass
print(f"Broken app on :{PORT}", flush=True)
socketserver.TCPServer(("", PORT), H).serve_forever()
PYEOF

docker build --build-arg APP_VERSION=v3-broken -t myapp:v3-broken -f - /tmp << 'EOF' 2>/dev/null
FROM python:3.11-alpine
ENV APP_VERSION=v3-broken
WORKDIR /app
COPY app_broken.py app.py
EXPOSE 8080
CMD ["python3", "app.py"]
EOF
echo "Сломанный образ собран"
```{{execute}}

```bash
echo "Деплоим сломанный v3 — должен сработать авто-откат на v2..."
./deploy-with-rollback.sh v3-broken v2 || true
```{{execute}}

```bash
docker stop myapp-prod 2>/dev/null; docker rm myapp-prod 2>/dev/null || true
```{{execute}}
