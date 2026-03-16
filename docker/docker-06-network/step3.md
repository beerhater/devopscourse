# Шаг 3: Создание пользовательских сетей

**Пользовательская bridge-сеть** решает проблему DNS — контейнеры в ней обращаются друг к другу по имени.

## Создание сети

```bash
docker network create my-network
```{{execute}}

```bash
docker network ls
```{{execute}}

## Создание сети с параметрами

```bash
docker network create \
  --driver bridge \
  --subnet 172.20.0.0/16 \
  --gateway 172.20.0.1 \
  --ip-range 172.20.1.0/24 \
  app-network
```{{execute}}

```bash
docker network inspect app-network | grep -A10 '"IPAM"'
```{{execute}}

## Запуск контейнеров в пользовательской сети

```bash
docker run -d --name web --network app-network nginx:alpine
docker run -d --name cache --network app-network redis:alpine
```{{execute}}

## Проверьте, кто в сети

```bash
docker network inspect app-network | grep -A5 '"Containers"'
```{{execute}}

Оба контейнера видны в сети `app-network`.
