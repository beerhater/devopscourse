# Шаг 1: depends_on и порядок запуска

## Проблема простого depends_on

```yaml
depends_on:
  - db
```

Это гарантирует что **контейнер** `db` запущен, но **не** что PostgreSQL внутри готов принимать соединения. Приложение стартует раньше и падает с ошибкой подключения.

## Демонстрация проблемы

```bash
mkdir -p /opt/compose2 && cd /opt/compose2
```{{execute}}

```bash
cat > docker-compose.yml << 'COMPOSEFILE'
services:
  db:
    image: postgres:15-alpine
    environment:
      POSTGRES_PASSWORD: secret

  app:
    image: alpine
    command: sh -c "echo 'Connecting to DB...' && sleep 2 && echo 'Done'"
    depends_on:
      - db
COMPOSEFILE
```{{execute}}

```bash
docker-compose up
```{{execute}}

`app` стартует почти одновременно с `db` — `depends_on` лишь задаёт порядок, не ждёт готовности.

## Решение: condition: service_healthy

```bash
docker-compose down
```{{execute}}

```bash
cat > docker-compose.yml << 'COMPOSEFILE'
services:
  db:
    image: postgres:15-alpine
    environment:
      POSTGRES_PASSWORD: secret
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U postgres"]
      interval: 5s
      timeout: 5s
      retries: 5

  app:
    image: alpine
    command: sh -c "echo 'DB is ready!' && echo 'Connected OK'"
    depends_on:
      db:
        condition: service_healthy
COMPOSEFILE
```{{execute}}

```bash
docker-compose up
```{{execute}}

Теперь `app` стартует только когда PostgreSQL реально готов!

```bash
docker-compose down
```{{execute}}
