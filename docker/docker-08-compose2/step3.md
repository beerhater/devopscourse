## healthcheck — ждём готовности сервиса

`healthcheck` периодически проверяет здоров ли сервис.
Статусы: `starting` → `healthy` / `unhealthy`.

`depends_on` с условием `condition: service_healthy`
ждёт не просто запуска, а статуса `healthy` — это настоящее ожидание готовности!

---

1. Обновите docker-compose.yml:
`nano /root/prodstack/docker-compose.yml`

2. Добавьте healthcheck к db и условие к app:
```yaml
version: "3.9"

services:
  db:
    image: postgres:15
    environment:
      POSTGRES_PASSWORD: ${POSTGRES_PASSWORD}
      POSTGRES_DB: ${POSTGRES_DB}
      POSTGRES_USER: ${POSTGRES_USER}
    volumes:
      - pgdata:/var/lib/postgresql/data
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U ${POSTGRES_USER:-postgres}"]
      interval: 5s
      timeout: 5s
      retries: 5

  cache:
    image: redis:7-alpine
    healthcheck:
      test: ["CMD", "redis-cli", "ping"]
      interval: 5s
      timeout: 3s
      retries: 5

  app:
    image: alpine
    command: sh -c "echo 'DB is ready! App starting...' && sleep 300"
    depends_on:
      db:
        condition: service_healthy
      cache:
        condition: service_healthy

volumes:
  pgdata:
```
