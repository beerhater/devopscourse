# Шаг 5: Feature Flags

## Концепция

Feature flag — **рубильник в коде**: фича задеплоена, но отключена. Включается без нового деплоя — через переменную окружения.

```
БЕЗ FEATURE FLAGS:
  Деплой → фича включена у всех сразу
  Откат = новый деплой старой версии (долго!)

С FEATURE FLAGS:
  Деплой → фича выключена (FF_NEW_DASHBOARD=false)
  Включить для 5% → тестируем
  Включить для 100% → успех
  Проблема? → FF_NEW_DASHBOARD=false → мгновенный откат, новый деплой не нужен
```

```bash
cd /opt/deploy-demo
```{{execute}}

```bash
cat > app_with_flags.py << 'PYEOF'
import http.server, socketserver, json, os

VERSION  = os.environ.get("APP_VERSION", "v3.0.0")
PORT     = int(os.environ.get("APP_PORT", "8080"))
FEATURES = {
    "new_dashboard": os.environ.get("FF_NEW_DASHBOARD", "false").lower() == "true",
    "dark_mode":     os.environ.get("FF_DARK_MODE",     "false").lower() == "true",
    "new_checkout":  os.environ.get("FF_NEW_CHECKOUT",  "false").lower() == "true",
}

def get_dashboard():
    if FEATURES["new_dashboard"]:
        return {"dashboard": "new", "widgets": ["analytics", "graph", "ai-insights"]}
    return {"dashboard": "classic", "widgets": ["summary", "chart"]}

def get_checkout():
    if FEATURES["new_checkout"]:
        return {"checkout": "v2", "steps": ["cart","shipping","payment","confirm"], "one_click": True}
    return {"checkout": "v1", "steps": ["cart","address","card","done"]}

class Handler(http.server.BaseHTTPRequestHandler):
    def do_GET(self):
        path = self.path.split("?")[0]
        if path == "/dashboard": body, code = get_dashboard(), 200
        elif path == "/checkout": body, code = get_checkout(), 200
        elif path == "/flags":   body, code = {"version": VERSION, "features": FEATURES}, 200
        elif path == "/health":  body, code = {"status": "ok", "version": VERSION}, 200
        else: body, code = {"version": VERSION, "flags_enabled": sum(FEATURES.values())}, 200
        self.send_response(code)
        self.send_header("Content-type", "application/json")
        self.end_headers()
        self.wfile.write(json.dumps(body, indent=2).encode())
    def log_message(self, *a): pass

if __name__ == "__main__":
    enabled = [k for k,v in FEATURES.items() if v]
    print(f"Starting {VERSION} | Enabled: {enabled or ['none']}", flush=True)
    with socketserver.TCPServer(("", PORT), Handler) as s: s.serve_forever()
PYEOF
```{{execute}}

```bash
docker stop ff-demo 2>/dev/null; docker rm ff-demo 2>/dev/null || true
docker run -d --name ff-demo -p 8095:8080 -e APP_VERSION=v3.0.0 \
  -v /opt/deploy-demo/app_with_flags.py:/app/app.py myapp:v1 2>/dev/null
sleep 2
echo "=== Все флаги ВЫКЛЮЧЕНЫ ==="
curl -sf http://localhost:8095/flags | python3 -m json.tool
```{{execute}}

```bash
echo "Dashboard без флага:"; curl -sf http://localhost:8095/dashboard | python3 -m json.tool
```{{execute}}

```bash
docker stop ff-demo; docker rm ff-demo
docker run -d --name ff-demo -p 8095:8080 \
  -e APP_VERSION=v3.0.0 -e FF_NEW_DASHBOARD=true -e FF_NEW_CHECKOUT=true \
  -v /opt/deploy-demo/app_with_flags.py:/app/app.py myapp:v1 2>/dev/null
sleep 2
echo "=== new_dashboard + new_checkout ВКЛЮЧЕНЫ ==="
curl -sf http://localhost:8095/flags | python3 -m json.tool
```{{execute}}

```bash
echo "Dashboard (ON):"; curl -sf http://localhost:8095/dashboard | python3 -m json.tool
echo ""; echo "Checkout (ON):"; curl -sf http://localhost:8095/checkout | python3 -m json.tool
```{{execute}}

```bash
docker stop ff-demo 2>/dev/null; docker rm ff-demo 2>/dev/null || true
```{{execute}}
