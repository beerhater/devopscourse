# Шаг 5: Профили — запуск нужных сервисов

**Profiles** позволяют помечать сервисы тегами. Сервисы без профиля запускаются всегда, с профилем — только при явном `--profile`. Идеально для dev-инструментов и миграций.

## Задание

```bash
cd /opt/compose2
```{{execute}}

```bash
cat > docker-compose.yml << 'COMPOSEFILE'
services:
  app:
    build: ./app
    ports:
      - "5000:5000"

  redis:
    image: redis:alpine

  db:
    image: postgres:15-alpine
    environment:
      POSTGRES_PASSWORD: secret

  adminer:
    image: adminer
    ports:
      - "8081:8080"
    profiles: ["dev"]
    depends_on:
      - db

  redis-commander:
    image: rediscommander/redis-commander
    environment:
      REDIS_HOSTS: local:redis:6379
    ports:
      - "8082:8081"
    profiles: ["dev"]

  db-init:
    image: postgres:15-alpine
    environment:
      PGPASSWORD: secret
    command: sh -c "psql -h db -U postgres -c 'SELECT 1' && echo 'DB OK'"
    profiles: ["tools"]
    depends_on:
      - db
COMPOSEFILE
```{{execute}}

Только основные сервисы:
```bash
docker compose up -d --build
docker compose ps
```{{execute}}

С dev-инструментами:
```bash
docker compose --profile dev up -d
docker compose ps
```{{execute}}

```bash
docker compose --profile dev down
```{{execute}}
