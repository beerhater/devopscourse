# Шаг 5: Удаление контейнера — docker rm

`docker stop` останавливает контейнер, но **не удаляет** его. Остановленные контейнеры занимают место на диске. `docker rm` удаляет контейнер полностью.

## Задание 1: Удаление остановленного контейнера

```bash
docker rm my-nginx
```{{execute}}

Проверьте, что контейнер удалён:

```bash
docker ps -a --filter "name=my-nginx"
```{{execute}}

## Задание 2: Удаление нескольких контейнеров

```bash
docker rm test-stop
```{{execute}}

## Задание 3: Принудительное удаление работающего контейнера

Флаг `-f` останавливает и удаляет за одну команду:

```bash
docker run -d --name force-test nginx
docker rm -f force-test
```{{execute}}

## Очистка всех остановленных контейнеров

```bash
docker container prune
```{{execute}}
