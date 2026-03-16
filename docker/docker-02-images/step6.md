# Шаг 6: Удаление образов — docker rmi

Образы занимают место на диске. `docker rmi` удаляет ненужные образы.

## Синтаксис

```
docker rmi [OPTIONS] IMAGE [IMAGE...]
```

## Задание 1: Удаление по имени и тегу

```bash
docker rmi ubuntu:20.04
```{{execute}}

## Задание 2: Удаление по IMAGE ID

Узнайте ID образа:

```bash
docker images -q nginx
```{{execute}}

Удалите конкретный тег:

```bash
docker rmi nginx:1.25
```{{execute}}

## Задание 3: Удаление нескольких образов сразу

```bash
docker rmi ubuntu:22.04 redis:alpine
```{{execute}}

## Ошибка: образ используется контейнером

Если на основе образа есть контейнеры (даже остановленные), Docker не даст удалить образ:

```bash
docker run --name test-container alpine echo "test"
docker rmi alpine
```{{execute}}

Сначала нужно удалить контейнер:

```bash
docker rm test-container
docker rmi alpine
```{{execute}}

## Очистка всех неиспользуемых образов

```bash
docker image prune -a
```{{execute}}

> Флаг `-a` удаляет все образы, к которым нет ни одного контейнера. Без `-a` удаляются только "висячие" образы без тега.
