# Шаг 4: Масштабирование — --scale

Compose позволяет запускать **несколько реплик** одного сервиса.

## Важное условие

Масштабируемый сервис не должен иметь `container_name` и должен использовать `expose` вместо `ports` — иначе второй контейнер не сможет занять тот же порт хоста.

## Задание

```bash
cd /opt/compose2
```{{execute}}

```bash
cat > docker-compose.yml << 'COMPOSEFILE'
services:
  app:
    build: ./app
    expose:
      - "5000"

  nginx:
    image: nginx:alpine
    ports:
      - "8080:80"

  redis:
    image: redis:alpine
COMPOSEFILE
```{{execute}}

```bash
docker-compose up -d --build
```{{execute}}

Запустите 3 реплики:
```bash
docker-compose up -d --scale app=3
```{{execute}}

```bash
docker-compose ps
```{{execute}}

Три контейнера: `compose2_app_1`, `compose2_app_2`, `compose2_app_3`.

Уменьшите до 1:
```bash
docker-compose up -d --scale app=1
docker-compose ps
```{{execute}}

```bash
docker-compose down
```{{execute}}
