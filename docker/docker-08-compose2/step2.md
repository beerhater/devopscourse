# Шаг 2: Healthcheck — проверка готовности

**Healthcheck** — периодическая проверка работоспособности сервиса. Docker помечает контейнер как `healthy` или `unhealthy`.

## Параметры healthcheck

```yaml
healthcheck:
  test: ["CMD", "curl", "-f", "http://localhost"]
  interval: 30s
  timeout: 10s
  retries: 3
  start_period: 40s
```

## Задание: стек с healthcheck для всех сервисов

```bash
cd /opt/compose2
```{{execute}}

```bash
cat > docker-compose.yml << 'COMPOSEFILE'
services:
  nginx:
    image: nginx:alpine
    ports:
      - "8080:80"
    healthcheck:
      test: ["CMD", "wget", "-qO-", "http://localhost"]
      interval: 10s
      timeout: 5s
      retries: 3
      start_period: 5s

  redis:
    image: redis:alpine
    healthcheck:
      test: ["CMD", "redis-cli", "ping"]
      interval: 10s
      timeout: 5s
      retries: 3

  db:
    image: postgres:15-alpine
    environment:
      POSTGRES_PASSWORD: secret
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U postgres"]
      interval: 10s
      timeout: 5s
      retries: 5
      start_period: 10s

  app:
    image: alpine
    command: sh -c "echo 'All healthy!' && sleep infinity"
    depends_on:
      nginx:
        condition: service_healthy
      redis:
        condition: service_healthy
      db:
        condition: service_healthy
COMPOSEFILE
```{{execute}}

```bash
docker compose up -d
```{{execute}}

Следим за статусом — `starting` -> `healthy`:
```bash
for i in $(seq 1 10); do
  docker compose ps
  sleep 2
done
```{{execute}}

Такой цикл безопаснее для Killercoda, чем бесконечный `watch`.

```bash
docker compose ps
```{{execute}}

```bash
docker compose down
```{{execute}}
