# Шаг 2: Инструкции FROM и RUN

## FROM — базовый образ

`FROM` — первая инструкция в любом Dockerfile. Она задаёт базовый образ, на основе которого строится ваш:

```
FROM <image>[:<tag>]
```

Выбор базового образа важен: `ubuntu` (~30 МБ), `debian:slim` (~25 МБ), `alpine` (~5 МБ).

## RUN — выполнение команд при сборке

`RUN` выполняет команду **во время сборки** образа и сохраняет результат как новый слой:

```
RUN <команда>
```

## Задание: объединяйте RUN-команды

Плохая практика — несколько отдельных `RUN`:
```dockerfile
RUN apt-get update
RUN apt-get install -y curl
RUN apt-get install -y wget
```
Это создаёт 3 лишних слоя!

Хорошая практика — объединять через `&&` и `\`:

```bash
cd /opt/myapp
cat > Dockerfile << 'DOCKERFILE'
FROM alpine:3.18

RUN apk update && \
    apk add --no-cache \
      curl \
      wget \
      bash

CMD ["bash"]
DOCKERFILE
```{{execute}}

```bash
docker build -t my-alpine-app .
```{{execute}}

```bash
docker run --rm my-alpine-app curl --version
```{{execute}}

Флаг `--no-cache` в `apk` (и `--no-install-recommends` в `apt`) уменьшает размер образа.
