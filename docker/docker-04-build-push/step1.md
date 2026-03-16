# Шаг 1: docker build — флаги и контекст сборки

## Контекст сборки

Когда вы запускаете `docker build .`, точка `.` — это **контекст сборки**: директория, содержимое которой Docker отправляет в build-daemon. Чем меньше файлов — тем быстрее сборка. Именно поэтому важен `.dockerignore`.

## Основные флаги docker build

```
docker build [OPTIONS] PATH
```

| Флаг | Описание |
|------|----------|
| `-t name:tag` | Имя и тег образа |
| `-f Dockerfile.prod` | Путь к Dockerfile (если не дефолтный) |
| `--no-cache` | Сборка без кеша |
| `--build-arg KEY=VAL` | Передать ARG-переменную |
| `--target stage` | Собрать до конкретного этапа (multi-stage) |
| `--platform` | Целевая платформа (linux/amd64, linux/arm64) |

## Задание: подготовьте приложение

```bash
mkdir -p /opt/buildapp && cd /opt/buildapp
```{{execute}}

```bash
cat > app.sh << 'SCRIPT'
#!/bin/sh
echo "App version: ${APP_VERSION:-unknown}"
echo "Built at: ${BUILD_DATE:-unknown}"
echo "Running on: $(uname -m)"
SCRIPT
```{{execute}}

```bash
cat > Dockerfile << 'DOCKERFILE'
FROM alpine:3.18
ARG APP_VERSION=dev
ARG BUILD_DATE=unknown
ENV APP_VERSION=$APP_VERSION
ENV BUILD_DATE=$BUILD_DATE
WORKDIR /app
COPY app.sh .
RUN chmod +x app.sh
CMD ["./app.sh"]
DOCKERFILE
```{{execute}}

Сборка с тегом и build-args:

```bash
docker build \
  -t buildapp:1.0 \
  --build-arg APP_VERSION=1.0.0 \
  --build-arg BUILD_DATE=$(date +%Y-%m-%d) \
  .
```{{execute}}

```bash
docker run --rm buildapp:1.0
```{{execute}}
