# Шаг 2: Rolling Update

## Концепция

Заменяем 4 инстанса по одному — в каждый момент времени работают хотя бы 3:

```
ДО:    [v1] [v1] [v1] [v1]  — все обслуживают трафик
Шаг 1: [v2] [v1] [v1] [v1]  — заменили #1, трафик на 3 остальных
Шаг 2: [v2] [v2] [v1] [v1]
Шаг 3: [v2] [v2] [v2] [v1]
ПОСЛЕ: [v2] [v2] [v2] [v2]  — нулевой downtime ✓
```

**Важно:** во время rolling update одновременно работают v1 и v2. Это требует обратной совместимости API и БД-миграций.

```bash
cd /opt/deploy-demo
```{{execute}}

```bash
cat > rolling-deploy.sh << 'BASH'
#!/bin/bash
NEW_VERSION=${1:-v2}
PORTS=(8081 8082 8083 8084)
TOTAL=${#PORTS[@]}
echo "=== ROLLING UPDATE -> $NEW_VERSION (инстансов: $TOTAL) ==="

for i in "${!PORTS[@]}"; do
    PORT=${PORTS[$i]}
    NUM=$((i + 1))
    TEMP_PORT=$((PORT + 100))

    echo ""; echo "--- Шаг $NUM/$TOTAL: обновляем :$PORT ---"
    docker run -d --name "myapp-new-$i" -p $TEMP_PORT:8080 myapp:$NEW_VERSION > /dev/null

    echo "  Health check нового инстанса..."
    ok=0
    for attempt in 1 2 3 4 5; do
        curl -sf http://localhost:$TEMP_PORT/health > /dev/null 2>&1 && ok=1 && break
        sleep 1
    done
    if [ $ok -eq 0 ]; then
        echo "  ОШИБКА: инстанс не ответил — останавливаем деплой!"
        docker stop "myapp-new-$i" 2>/dev/null; docker rm "myapp-new-$i" 2>/dev/null
        exit 1
    fi
    echo "  OK. Выводим старый инстанс :$PORT..."
    docker stop "myapp-$i" 2>/dev/null; docker rm "myapp-$i" 2>/dev/null || true
    docker stop "myapp-new-$i" 2>/dev/null; docker rm "myapp-new-$i" 2>/dev/null
    docker run -d --name "myapp-$i" -p $PORT:8080 myapp:$NEW_VERSION > /dev/null
    VER=$(curl -sf http://localhost:$PORT/info 2>/dev/null | python3 -c "import sys,json; print(json.load(sys.stdin)['version'])" || echo "?")
    echo "  Инстанс $NUM готов: $VER"
    sleep 1
done

echo ""; echo "=== Rolling update завершён ==="
for PORT in "${PORTS[@]}"; do
    VER=$(curl -sf http://localhost:$PORT/info 2>/dev/null | python3 -c "import sys,json; print(json.load(sys.stdin)['version'])" || echo "?")
    echo "  :$PORT -> $VER"
done
BASH
chmod +x rolling-deploy.sh
```{{execute}}

```bash
echo "Запускаем 4 инстанса v1..."
for i in 0 1 2 3; do
    docker stop "myapp-$i" 2>/dev/null; docker rm "myapp-$i" 2>/dev/null || true
    docker run -d --name "myapp-$i" -p $((8081+i)):8080 myapp:v1 > /dev/null
done
sleep 2; echo "Готово:"
for i in 0 1 2 3; do
    VER=$(curl -sf http://localhost:$((8081+i))/info 2>/dev/null | python3 -c "import sys,json; print(json.load(sys.stdin)['version'])" || echo "?")
    echo "  :$((8081+i)) -> $VER"
done
```{{execute}}

```bash
./rolling-deploy.sh v2
```{{execute}}

```bash
for i in 0 1 2 3; do docker stop "myapp-$i" 2>/dev/null; docker rm "myapp-$i" 2>/dev/null || true; done
echo "Cleanup done"
```{{execute}}
