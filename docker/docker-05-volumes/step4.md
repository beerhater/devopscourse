# Шаг 4: Bind mounts — монтирование директорий хоста

**Bind mount** монтирует конкретную директорию или файл с хоста прямо в контейнер. В отличие от томов, вы сами контролируете путь на хосте.

## Синтаксис

```
-v /host/path:/container/path[:ro]
--mount type=bind,source=/host/path,target=/container/path
```

## Главное применение: разработка

Bind mount позволяет редактировать код на хосте и сразу видеть изменения в контейнере — без пересборки образа.

## Задание 1: Живой код в контейнере

Создайте файл на хосте:

```bash
mkdir -p /opt/webdev
echo "<h1>Hello from bind mount!</h1>" > /opt/webdev/index.html
```{{execute}}

Запустите nginx с bind mount:

```bash
docker run -d \
  --name dev-nginx \
  -p 8080:80 \
  -v /opt/webdev:/usr/share/nginx/html:ro \
  nginx:alpine
```{{execute}}

```bash
curl http://localhost:8080
```{{execute}}

Измените файл на хосте — изменения сразу в контейнере:

```bash
echo "<h1>Updated without rebuild!</h1>" > /opt/webdev/index.html
curl http://localhost:8080
```{{execute}}

## Задание 2: Монтирование отдельного файла

```bash
cat > /opt/nginx.conf << 'CONF'
server {
    listen 80;
    location / {
        return 200 'Custom nginx config!\n';
        add_header Content-Type text/plain;
    }
}
CONF
```{{execute}}

```bash
docker stop dev-nginx && docker rm dev-nginx
docker run -d --name dev-nginx2 -p 8080:80 \
  -v /opt/nginx.conf:/etc/nginx/conf.d/default.conf:ro \
  nginx:alpine
curl http://localhost:8080
```{{execute}}

> **Флаг `:ro`** (read-only) запрещает контейнеру писать в примонтированную директорию — хорошая практика для конфигов.
