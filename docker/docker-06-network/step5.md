# Шаг 5: Сеть host и none

## Драйвер host

Контейнер с `--network host` использует сетевой стек хоста напрямую — без виртуальных интерфейсов и NAT.

```bash
docker run --rm --network host alpine ip addr
```{{execute}}

Вы видите все интерфейсы хоста — `eth0`, `lo` и другие. Контейнер буквально является частью сети хоста.

**Когда использовать host:**
- Максимальная сетевая производительность
- Приложения, которые слушают много портов динамически
- Мониторинг сетевого трафика хоста

**Ограничение:** не работает на Docker Desktop (macOS/Windows) — только на Linux.

## Драйвер none — полная изоляция

```bash
docker run --rm --network none alpine ip addr
```{{execute}}

Только интерфейс `lo` (loopback). Нет возможности ни входящих, ни исходящих сетевых соединений.

**Когда использовать none:**
- Обработка данных без доступа в сеть (безопасность)
- Batch-задачи, которым сеть не нужна

## Подключение контейнера к нескольким сетям

Контейнер может быть в нескольких сетях одновременно:

```bash
docker network create frontend-net
docker network create backend-net

docker run -d --name api-server --network frontend-net nginx:alpine
docker network connect backend-net api-server

docker network inspect frontend-net | grep -A3 '"Containers"'
docker network inspect backend-net | grep -A3 '"Containers"'
```{{execute}}

`api-server` теперь виден в обеих сетях и может общаться с контейнерами в каждой из них.
