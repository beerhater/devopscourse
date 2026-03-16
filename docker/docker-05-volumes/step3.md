# Шаг 3: Монтирование томов — флаг -v и --mount

Есть два синтаксиса для монтирования тома в контейнер.

## Синтаксис -v (краткий)

```
-v [volume-name:]container-path[:options]
```

## Синтаксис --mount (явный, рекомендуется)

```
--mount type=volume,source=vol-name,target=/path
```

## Задание 1: Персистентная база данных PostgreSQL

Запустите PostgreSQL с томом для данных:

```bash
docker volume create pg-data
```{{execute}}

```bash
docker run -d \
  --name postgres-db \
  -e POSTGRES_PASSWORD=secret \
  -e POSTGRES_DB=mydb \
  -v pg-data:/var/lib/postgresql/data \
  postgres:15-alpine
```{{execute}}

```bash
sleep 3 && docker exec postgres-db psql -U postgres -d mydb -c \
  "CREATE TABLE users (id SERIAL, name TEXT); INSERT INTO users(name) VALUES ('Alice'), ('Bob');"
```{{execute}}

Удалите контейнер:

```bash
docker stop postgres-db && docker rm postgres-db
```{{execute}}

Запустите новый контейнер с тем же томом — данные сохранились:

```bash
docker run -d \
  --name postgres-db2 \
  -e POSTGRES_PASSWORD=secret \
  -e POSTGRES_DB=mydb \
  -v pg-data:/var/lib/postgresql/data \
  postgres:15-alpine
```{{execute}}

```bash
sleep 3 && docker exec postgres-db2 psql -U postgres -d mydb -c "SELECT * FROM users;"
```{{execute}}

Alice и Bob никуда не делись!
