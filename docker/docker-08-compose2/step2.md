## Переменные окружения и .env файл

Жёстко прописывать пароли в docker-compose.yml — плохая практика.
Файл попадёт в git и пароль станет публичным.

Решение: `.env` файл рядом с `docker-compose.yml`.
Compose автоматически читает `.env` и подставляет значения через `${VAR}`.

---

1. Создайте `.env` файл:
`nano /root/prodstack/.env`

2. Введите:
```
POSTGRES_PASSWORD=superSecret123
POSTGRES_DB=appdb
POSTGRES_USER=appuser
REDIS_PORT=6379
```

3. Обновите `docker-compose.yml`:
`nano /root/prodstack/docker-compose.yml`

4. Введите:
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

  cache:
    image: redis:7-alpine
    ports:
      - "${REDIS_PORT}:6379"

volumes:
  pgdata:
```

5. `.env` должен быть в `.gitignore`:
`echo ".env" >> /root/prodstack/.gitignore`
