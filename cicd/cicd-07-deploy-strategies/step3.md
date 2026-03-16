# Шаг 3: Blue/Green

## Концепция

Два одинаковых окружения работают параллельно:

```
ПРОДАКШН (v1):
  Пользователи → nginx → [Blue:  v1] ← АКТИВЕН
                          [Green: v2] ← ПРОСТАИВАЕТ (прогрет, готов)

ПЕРЕКЛЮЧЕНИЕ (одна команда, ~0ms):
  Пользователи → nginx → [Blue:  v1] ← ПРОСТАИВАЕТ
                          [Green: v2] ← АКТИВЕН

ПРОБЛЕМА В v2 → ОТКАТ (одна команда):
  Пользователи → nginx → [Blue:  v1] ← АКТИВЕН снова ✓
```

Главное преимущество: **старое окружение всегда живо** — откат мгновенный.

```bash
cd /opt/deploy-demo
```{{execute}}

```bash
cat > bg-deploy.sh << 'BASH'
#!/bin/bash
BLUE_PORT=8091; GREEN_PORT=8092
STATE_FILE=/tmp/bg-active-env

get_active()   { cat "$STATE_FILE" 2>/dev/null || echo "blue"; }
get_inactive() { [ "$(get_active)" = "blue" ] && echo "green" || echo "blue"; }
get_port()     { [ "$1" = "blue" ] && echo $BLUE_PORT || echo $GREEN_PORT; }

status() {
    local act=$(get_active) inact=$(get_inactive)
    echo "=== Blue/Green статус ==="; echo "АКТИВЕН: $act (:$(get_port $act))"; echo ""
    for env in blue green; do
        port=$(get_port $env)
        ver=$(curl -sf http://localhost:$port/info 2>/dev/null | python3 -c "import sys,json; print(json.load(sys.stdin)['version'])" 2>/dev/null || echo "не запущен")
        marker=""; [ "$env" = "$act" ] && marker=" ← АКТИВЕН"
        echo "  $env (:$port): $ver$marker"
    done
}

deploy() {
    local ver=$1 inact=$(get_inactive)
    local port=$(get_port $inact)
    echo "=== ДЕПЛОЙ $ver → $inact (:$port) ==="
    docker stop "myapp-$inact" 2>/dev/null; docker rm "myapp-$inact" 2>/dev/null || true
    docker run -d --name "myapp-$inact" -p $port:8080 myapp:$ver > /dev/null
    echo "Ждём старта..."
    for i in $(seq 1 10); do
        curl -sf http://localhost:$port/health > /dev/null 2>&1 && echo "Health check OK" && break
        [ $i -eq 10 ] && echo "ОШИБКА: инстанс не ответил!" && exit 1; sleep 1
    done
    echo "Переключаем трафик: $(get_active) → $inact"
    echo $inact > $STATE_FILE
    echo "Готово!"; echo ""; status
}

rollback() {
    local prev=$(get_inactive)
    echo "=== ОТКАТ → $prev ==="
    curl -sf http://localhost:$(get_port $prev)/health > /dev/null 2>&1 || { echo "ОШИБКА: $prev не запущен!"; exit 1; }
    echo $prev > $STATE_FILE
    echo "Трафик переключён на $prev"; status
}

case $1 in deploy) deploy $2;; rollback) rollback;; status) status;; *) echo "Использование: $0 {deploy <ver>|rollback|status}";; esac
BASH
chmod +x bg-deploy.sh
```{{execute}}

```bash
docker stop myapp-blue myapp-green 2>/dev/null; docker rm myapp-blue myapp-green 2>/dev/null || true
docker run -d --name myapp-blue -p 8091:8080 myapp:v1 > /dev/null
echo "blue" > /tmp/bg-active-env; sleep 2
echo "Начальное состояние:"; ./bg-deploy.sh status
```{{execute}}

```bash
./bg-deploy.sh deploy v2
```{{execute}}

```bash
echo "Обнаружена проблема с v2 → откатываемся..."
./bg-deploy.sh rollback
```{{execute}}

```bash
# Всё ок — деплоим v2 снова
./bg-deploy.sh deploy v2
```{{execute}}

```bash
docker stop myapp-blue myapp-green 2>/dev/null; docker rm myapp-blue myapp-green 2>/dev/null || true
```{{execute}}
