# Шаг 3: Тегирование — docker tag

Тег — это указатель на конкретный образ (по IMAGE ID). Один образ может иметь **сколько угодно тегов**.

## Синтаксис

```
docker tag SOURCE_IMAGE[:TAG] TARGET_IMAGE[:TAG]
```

`docker tag` не копирует образ — оба тега указывают на один и тот же IMAGE ID.

## Задание 1: Добавьте теги к существующему образу

Посмотрите текущие образы:
```bash
docker images buildapp
```{{execute}}

Добавьте тег `latest`:
```bash
docker tag buildapp:1.0 buildapp:latest
```{{execute}}

Добавьте тег с датой:
```bash
docker tag buildapp:1.0 buildapp:$(date +%Y%m%d)
```{{execute}}

```bash
docker images buildapp
```{{execute}}

Все теги указывают на один IMAGE ID — убедитесь сами.

## Задание 2: Тег для публикации на Docker Hub

Для публикации на Docker Hub образ должен иметь тег вида `username/imagename:tag`:

```bash
docker tag buildapp:1.0 testuser/buildapp:1.0
docker tag buildapp:1.0 testuser/buildapp:latest
```{{execute}}

```bash
docker images testuser/buildapp
```{{execute}}

## Задание 3: Удалите тег

```bash
docker rmi buildapp:$(date +%Y%m%d)
```{{execute}}

Образ не удалился — удалился только тег. Убедитесь:
```bash
docker images buildapp
```{{execute}}
