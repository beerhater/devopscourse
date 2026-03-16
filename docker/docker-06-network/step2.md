# Шаг 2: Сеть bridge — сеть по умолчанию

Если при запуске контейнера не указать сеть, он попадает в сеть `bridge` по умолчанию.

## Задание 1: Запустите два контейнера

```bash
docker run -d --name container-a alpine sleep 300
docker run -d --name container-b alpine sleep 300
```{{execute}}

## Задание 2: Узнайте их IP-адреса

```bash
docker inspect container-a | grep '"IPAddress"'
docker inspect container-b | grep '"IPAddress"'
```{{execute}}

## Задание 3: Проверьте связь по IP

Получите IP контейнера B:

```bash
IP_B=$(docker inspect -f '{{.NetworkSettings.IPAddress}}' container-b)
echo "IP контейнера B: $IP_B"
```{{execute}}

Пингуйте из контейнера A:

```bash
docker exec container-a ping -c 3 $IP_B
```{{execute}}

Контейнеры видят друг друга по IP!

## Ограничение дефолтной bridge-сети

Попробуйте обратиться **по имени**:

```bash
docker exec container-a ping -c 2 container-b
```{{execute}}

**Ошибка!** В дефолтной bridge-сети нет DNS — контейнеры не знают имён друг друга, только IP. Это ограничение устраняется в пользовательских сетях.

```bash
docker stop container-a container-b && docker rm container-a container-b
```{{execute}}
