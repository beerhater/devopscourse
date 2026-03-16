# Шаг 5: Инструкции WORKDIR и ENV

## WORKDIR — рабочая директория

`WORKDIR` задаёт директорию, в которой будут выполняться последующие инструкции `RUN`, `CMD`, `ENTRYPOINT`, `COPY`, `ADD`:

```
WORKDIR /path/to/dir
```

Если директория не существует — Docker создаёт её автоматически. Лучше использовать `WORKDIR` вместо `RUN cd /some/path`.

## ENV — переменные окружения

`ENV` устанавливает переменные окружения, доступные **во время сборки и во время работы** контейнера:

```
ENV KEY=VALUE
```

## Задание: соберите приложение с WORKDIR и ENV

```bash
cd /opt/myapp
cat > Dockerfile << 'DOCKERFILE'
FROM alpine:3.18

# Переменные окружения
ENV APP_HOME=/app \
    APP_VERSION=2.0 \
    APP_ENV=production

# Устанавливаем рабочую директорию
WORKDIR $APP_HOME

# Копируем файл (путь относительно WORKDIR)
COPY hello.sh .

RUN chmod +x hello.sh

# CMD тоже выполняется относительно WORKDIR
CMD ["./hello.sh"]
DOCKERFILE
```{{execute}}

```bash
docker build -t workdir-demo .
docker run --rm workdir-demo
```{{execute}}

Проверьте переменные окружения внутри контейнера:

```bash
docker run --rm workdir-demo env
```{{execute}}

Переопределите переменную при запуске:

```bash
docker run --rm -e APP_ENV=staging workdir-demo env | grep APP_ENV
```{{execute}}
