## Практика — полный продакшн-стек

Соберём всё вместе: healthcheck + depends_on + .env + volumes + networks.

---

1. Создайте финальный стек:
`mkdir -p /root/finalstack && cd /root/finalstack`

2. Создайте .env:
`nano .env`

```
DB_PASSWORD=prod_secret_123
DB_NAME=production
APP_PORT=8080
```

3. Создайте docker-compose.yml:
`nano docker-compose.yml`

```yaml
version: "3.9"

networks:
  backend:
  frontend:

volumes:
  dbdata:

services:

  db:
    image: postgres:15
    environment:
      POSTGRES_PASSWORD: ${DB_PASSWORD}
      POSTGRES_DB: ${DB_NAME}
    volumes:
      - dbdata:/var/lib/postgresql/data
    networks:
      - backend
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U postgres"]
      interval: 5s
      timeout: 5s
      retries: 5

  cache:
    image: redis:7-alpine
    networks:
      - backend
    healthcheck:
      test: ["CMD", "redis-cli", "ping"]
      interval: 5s
      timeout: 3s
      retries: 3

  web:
    image: nginx:alpine
    ports:
      - "${APP_PORT}:80"
    networks:
      - frontend
      - backend
    depends_on:
      db:
        condition: service_healthy
      cache:
        condition: service_healthy
```

4. Запустите:
`docker compose up -d`

5. Проверьте что всё работает:
`docker compose ps`
`curl http://localhost:8080`
