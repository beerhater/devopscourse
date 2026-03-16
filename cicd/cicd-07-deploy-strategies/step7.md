# Шаг 7: Итоговое задание

Реализуем полный Blue/Green цикл и GitLab CI пайплайн со всеми изученными стратегиями.

## 1. Подготовка

```bash
mkdir -p /opt/final-deploy && cd /opt/final-deploy
```{{execute}}

## 2. Приложение и образы

```bash
cat > app.py << 'PYEOF'
import http.server, socketserver, json, os
VERSION  = os.environ.get("APP_VERSION", "v1.0.0")
PORT     = int(os.environ.get("APP_PORT", "8080"))
FEATURES = {
    "new_api":   os.environ.get("FF_NEW_API",   "false") == "true",
    "dark_mode": os.environ.get("FF_DARK_MODE", "false") == "true",
}
class Handler(http.server.BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path == "/health": body, code = {"status": "ok", "version": VERSION}, 200
        elif self.path == "/info": body, code = {"version": VERSION, "features": FEATURES}, 200
        else: body, code = {"app": "final-deploy-demo", "version": VERSION}, 200
        self.send_response(code); self.send_header("Content-type","application/json"); self.end_headers()
        self.wfile.write(json.dumps(body, indent=2).encode())
    def log_message(self, *a): pass
if __name__ == "__main__":
    print(f"App {VERSION} on :{PORT}", flush=True)
    with socketserver.TCPServer(("", PORT), Handler) as s: s.serve_forever()
PYEOF

cat > Dockerfile << 'EOF'
FROM python:3.11-alpine
ARG APP_VERSION=v1.0.0
ENV APP_VERSION=$APP_VERSION
WORKDIR /app; COPY app.py .; EXPOSE 8080
CMD ["python3", "app.py"]
EOF

for v in v1 v2 v3; do docker build --build-arg APP_VERSION=$v -t final-app:$v . -q; done
echo "Образы:"; docker images final-app
```{{execute}}

## 3. Smoke-тест

```bash
cat > smoke-test.sh << 'BASH'
#!/bin/bash
H=${1:-localhost}; P=${2:-8080}; F=0
check() {
    code=$(curl -sf -o /dev/null -w "%{http_code}" --max-time 3 "http://$H:$P$1" 2>/dev/null || echo "000")
    [ "$code" = "200" ] && echo "  OK  $1" || { echo "  FAIL $1 ($code)"; F=$((F+1)); }
}
echo "=== Smoke: http://$H:$P ==="; check /health; check /info; check /
[ $F -eq 0 ] && echo "PASSED" && exit 0 || { echo "FAILED"; exit 1; }
BASH
chmod +x smoke-test.sh
```{{execute}}

## 4. Blue/Green полный цикл

```bash
docker stop final-blue final-green 2>/dev/null; docker rm final-blue final-green 2>/dev/null || true
docker run -d --name final-blue  -p 9091:8080 final-app:v1 > /dev/null
docker run -d --name final-green -p 9092:8080 final-app:v1 > /dev/null
echo "blue" > /tmp/final-active; sleep 2
echo "Начальное состояние:"; for env in blue green; do
    port=$([[ $env == "blue" ]] && echo 9091 || echo 9092)
    ver=$(curl -sf http://localhost:$port/info | python3 -c "import sys,json; print(json.load(sys.stdin)['version'])" 2>/dev/null || echo "?")
    echo "  $env(:$port): $ver"
done
```{{execute}}

```bash
echo "Деплоим v2 в green..."
docker stop final-green; docker rm final-green
docker run -d --name final-green -p 9092:8080 final-app:v2 > /dev/null; sleep 2
./smoke-test.sh localhost 9092 && echo "" && echo "Smoke OK → переключаем трафик на green(v2)" && echo "green" > /tmp/final-active
echo "Активно: $(cat /tmp/final-active)"
```{{execute}}

```bash
echo "Обнаружена проблема → откат на blue(v1)..."
echo "blue" > /tmp/final-active
VER=$(curl -sf http://localhost:9091/info | python3 -c "import sys,json; print(json.load(sys.stdin)['version'])" 2>/dev/null)
echo "Активно: $(cat /tmp/final-active) | Версия: $VER"
```{{execute}}

## 5. GitLab CI пайплайн

```bash
cat > .gitlab-ci.yml << 'GLCI'
stages: [build, deploy, verify, promote]

variables:
  FF_NEW_API: "false"

build:
  stage: build
  script:
    - docker build --build-arg APP_VERSION=$CI_COMMIT_SHORT_SHA -t final-app:$CI_COMMIT_SHORT_SHA .
    - echo "Образ собран"

deploy-green:
  stage: deploy
  script:
    - docker stop deploy-green 2>/dev/null || true
    - docker rm deploy-green 2>/dev/null || true
    - docker run -d --name deploy-green -p 9092:8080 -e FF_NEW_API=$FF_NEW_API final-app:v2
  environment:
    name: green
    url: http://localhost:9092

smoke-test-green:
  stage: verify
  script:
    - sleep 3
    - ./smoke-test.sh localhost 9092
  after_script:
    - |
      if [ "$CI_JOB_STATUS" = "failed" ]; then
        echo "АВТО-ОТКАТ"
        docker stop deploy-green || true; docker rm deploy-green || true
        docker run -d --name deploy-green -p 9092:8080 final-app:v1 || true
      fi

switch-traffic:
  stage: promote
  when: manual
  script:
    - echo "green" > /tmp/final-active
    - echo "Деплой v2 в продакшн завершён!"
  environment:
    name: production
GLCI
python3 -c "import yaml; yaml.safe_load(open('.gitlab-ci.yml')); print('YAML OK')"
```{{execute}}

## 6. Финальная проверка

```bash
echo "=== Итог: стратегии деплоя ==="
echo "  1. Recreate:       stop → start (downtime есть)"
echo "  2. Rolling Update: по одному, health check, нулевой downtime"
echo "  3. Blue/Green:     два окружения, откат за 0мс"
echo "  4. Canary:         10%→50%→100%, nginx weight"
echo "  5. Feature Flags:  деплой без включения, откат без нового деплоя"
echo "  6. Smoke Tests:    авто-проверка + авто-откат при падении"
echo ""
docker stop final-blue final-green 2>/dev/null; docker rm final-blue final-green 2>/dev/null || true
echo "Модуль завершён!"
```{{execute}}
