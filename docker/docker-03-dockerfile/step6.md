# Шаг 6: EXPOSE, ARG и лучшие практики

## EXPOSE — документирование портов

`EXPOSE` сообщает, какие порты слушает контейнер. Это **только документация** — реальный проброс всё равно делается через `-p` при `docker run`:

```
EXPOSE 80
EXPOSE 8080/tcp
```

## ARG — аргументы сборки

`ARG` объявляет переменные, которые можно передать при сборке через `--build-arg`. В отличие от `ENV`, они недоступны в запущенном контейнере:

```
ARG VERSION=latest
```

## Задание: Dockerfile с EXPOSE и ARG

```bash
cd /opt/myapp
cat > Dockerfile << 'DOCKERFILE'
FROM alpine:3.18

# Аргумент сборки с дефолтным значением
ARG APP_VERSION=1.0.0

ENV VERSION=$APP_VERSION
ENV PORT=8080

WORKDIR /app

RUN apk add --no-cache python3

COPY hello.sh .
RUN chmod +x hello.sh

# Документируем порт
EXPOSE 8080

CMD ["./hello.sh"]
DOCKERFILE
```{{execute}}

Сборка с аргументом:
```bash
docker build --build-arg APP_VERSION=2.5.0 -t expose-demo .
docker run --rm expose-demo env | grep VERSION
```{{execute}}

## Лучшие практики Dockerfile

- **Минимальный базовый образ:** `alpine` вместо `ubuntu` там, где возможно
- **Объединяйте `RUN`** через `&&` — меньше слоёв, меньше размер
- **`.dockerignore`** — исключайте лишние файлы (аналог `.gitignore`)
- **Конкретные теги:** `FROM alpine:3.18`, а не `FROM alpine:latest`
- **`COPY` позже, чем `RUN`** — кешируйте установку зависимостей

```bash
echo -e "*.log\n.git\n__pycache__" > .dockerignore
cat .dockerignore
```{{execute}}
