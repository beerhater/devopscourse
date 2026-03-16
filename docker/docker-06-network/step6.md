# Шаг 6: Проброс портов и управление сетями

## Проброс портов -p

Контейнеры изолированы от хоста. Флаг `-p` публикует порт контейнера наружу:

```
-p [host_ip:]host_port:container_port[/protocol]
```

```bash
# Порт 8080 хоста → порт 80 контейнера
docker run -d --name nginx-pub -p 8080:80 nginx:alpine
curl http://localhost:8080
```{{execute}}

```bash
# Привязать только к localhost (не публично)
docker run -d --name nginx-local -p 127.0.0.1:8081:80 nginx:alpine
curl http://127.0.0.1:8081
```{{execute}}

```bash
# Случайный порт хоста
docker run -d --name nginx-random -p 80 nginx:alpine
docker port nginx-random
```{{execute}}

## Просмотр портов контейнера

```bash
docker port nginx-pub
```{{execute}}

## Отключение от сети

```bash
docker network disconnect backend-net api-server
docker network inspect backend-net | grep -A3 '"Containers"'
```{{execute}}

## Удаление сетей

```bash
docker stop nginx-pub nginx-local nginx-random api-server 2>/dev/null || true
docker rm nginx-pub nginx-local nginx-random api-server 2>/dev/null || true
docker network rm frontend-net backend-net my-network
```{{execute}}

Нельзя удалить сеть, к которой подключены контейнеры.

## Очистка всех неиспользуемых сетей

```bash
docker network prune
```{{execute}}
