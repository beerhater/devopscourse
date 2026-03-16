# Шаг 4: Canary

## Концепция

Отправляем малую часть реального трафика на новую версию:

```
БЕЗ CANARY:
  Деплой v2 → 100% пользователей → v2
  Если v2 сломан → все видят ошибки ✗

С CANARY:
  90% → v1 (stable)   10% → v2 (canary)
  Мониторим ошибки и латентность...
  Всё ок? → 50% / 50% → 100% v2
  Проблема? → возвращаем 100% на v1, пострадало только 10% запросов
```

Реализуем через **nginx weighted upstream**.

```bash
cd /opt/deploy-demo
```{{execute}}

```bash
cat > canary-deploy.sh << 'BASH'
#!/bin/bash
STABLE_PORT=8081; CANARY_PORT=8082; PROXY_PORT=8085
NGINX_CONF=/tmp/canary-nginx.conf

write_conf() {
    cat > $NGINX_CONF << NGINX
events { worker_connections 64; }
http {
    upstream app_pool {
        server localhost:$STABLE_PORT weight=${1:-9};
        server localhost:$CANARY_PORT weight=${2:-1};
    }
    server { listen $PROXY_PORT; location / { proxy_pass http://app_pool; } }
}
NGINX
}

case $1 in
start)
    docker stop myapp-stable myapp-canary 2>/dev/null; docker rm myapp-stable myapp-canary 2>/dev/null || true
    docker run -d --name myapp-stable -p $STABLE_PORT:8080 myapp:v1 > /dev/null
    docker run -d --name myapp-canary -p $CANARY_PORT:8080 myapp:v1 > /dev/null
    sleep 2; write_conf 1 0
    pkill -f "nginx.*canary-nginx" 2>/dev/null || true; sleep 1
    nginx -c $NGINX_CONF -g "daemon off;" &
    sleep 1; echo "Прокси запущен на :$PROXY_PORT"
    ;;
deploy-canary)
    ver=$2; pct=${3:-10}; sw=$((100-pct))
    echo "=== CANARY: $ver (${pct}% трафика) ==="
    docker stop myapp-canary 2>/dev/null; docker rm myapp-canary 2>/dev/null || true
    docker run -d --name myapp-canary -p $CANARY_PORT:8080 myapp:$ver > /dev/null; sleep 2
    curl -sf http://localhost:$CANARY_PORT/health > /dev/null && echo "Health check OK" || exit 1
    write_conf $sw $pct; nginx -s reload -c $NGINX_CONF 2>/dev/null || true
    echo "${sw}% → stable(v1)    ${pct}% → canary($ver)"
    ;;
promote)
    pct=${2:-100}; sw=$((100-pct))
    write_conf $sw $pct; nginx -s reload -c $NGINX_CONF 2>/dev/null || true
    echo "Промоут: ${sw}% stable / ${pct}% canary"
    [ "$pct" = "100" ] && echo "Деплой завершён — canary стал 100%!"
    ;;
rollback)
    write_conf 1 0; nginx -s reload -c $NGINX_CONF 2>/dev/null || true
    docker stop myapp-canary 2>/dev/null; docker rm myapp-canary 2>/dev/null || true
    docker run -d --name myapp-canary -p $CANARY_PORT:8080 myapp:v1 > /dev/null
    echo "Откат: 100% трафика на stable(v1)"
    ;;
traffic)
    echo "=== Распределение (20 запросов) ==="
    declare -A counts
    for i in $(seq 1 20); do
        v=$(curl -sf http://localhost:$PROXY_PORT/info 2>/dev/null | python3 -c "import sys,json; print(json.load(sys.stdin).get('version','?'))" 2>/dev/null || echo "err")
        counts[$v]=$((${counts[$v]:-0}+1))
    done
    for v in "${!counts[@]}"; do echo "  $v: ${counts[$v]}/20 запросов"; done
    ;;
*)  echo "Использование: $0 {start|deploy-canary <ver> [%]|promote [%]|rollback|traffic}";;
esac
BASH
chmod +x canary-deploy.sh
```{{execute}}

```bash
./canary-deploy.sh start
```{{execute}}

```bash
./canary-deploy.sh deploy-canary v2 10
```{{execute}}

```bash
./canary-deploy.sh traffic
```{{execute}}

```bash
./canary-deploy.sh promote 50 && ./canary-deploy.sh traffic
```{{execute}}

```bash
./canary-deploy.sh promote 100
```{{execute}}

```bash
pkill -f "nginx.*canary" 2>/dev/null || true
docker stop myapp-stable myapp-canary 2>/dev/null; docker rm myapp-stable myapp-canary 2>/dev/null || true
```{{execute}}
