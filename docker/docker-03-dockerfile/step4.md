## CMD vs ENTRYPOINT

Это самая часто путаемая пара инструкций. Разница принципиальная:

**CMD** — команда по умолчанию. Легко переопределить при `docker run`.
`docker run myapp echo "hello"` — заменит CMD на `echo "hello"`

**ENTRYPOINT** — точка входа. Аргументы `docker run` добавляются К ней.
`docker run myapp echo "hello"` — выполнит `entrypoint echo "hello"`

---

1. Добавьте CMD в Dockerfile:
`nano /root/myapp/Dockerfile`

2. Финальный вид файла:
```
FROM ubuntu:22.04

ENV APP_VERSION=1.0.0 \
    APP_ENV=production

RUN apt-get update && \
    apt-get install -y curl wget && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY app.sh /app/app.sh
RUN chmod +x /app/app.sh

EXPOSE 8080

CMD ["/app/app.sh"]
```

Сохраните файл.
