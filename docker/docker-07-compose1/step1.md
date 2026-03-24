# Шаг 1: Что такое Docker Compose

**Docker Compose** — инструмент для описания и запуска многоконтейнерных приложений. Всё описание — в одном YAML-файле `docker-compose.yml`.

## Было: запуск вручную

Без Compose запуск стека nginx + postgres + redis выглядит так:

```bash
docker network create app-net
docker volume create db-data
docker run -d --name db --network app-net \
  -v db-data:/var/lib/postgresql/data \
  -e POSTGRES_PASSWORD=secret postgres:15-alpine
docker run -d --name cache --network app-net redis:alpine
docker run -d --name web --network app-net -p 8080:80 nginx:alpine
```

Это 5 команд. А если их нужно воспроизвести на другой машине?

## Стало: один файл

```yaml
services:
  web:
    image: nginx:alpine
    ports:
      - "8080:80"
  db:
    image: postgres:15-alpine
    environment:
      POSTGRES_PASSWORD: secret
    volumes:
      - db-data:/var/lib/postgresql/data
  cache:
    image: redis:alpine
volumes:
  db-data:
```

Запуск: `docker compose up -d` — одна команда вместо пяти!

## Проверьте версию

```bash
docker compose version
```{{execute}}

> В современных окружениях Killercoda обычно доступна команда `docker compose` (через пробел). Её и используем в курсе.
