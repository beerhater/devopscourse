## ENV и EXPOSE

`ENV` задаёт переменные окружения. Они доступны **во время сборки и в контейнере**.
`EXPOSE` документирует порт который слушает приложение.
Важно: EXPOSE это только документация, реально порт открывается флагом `-p` при запуске.

---

1. Обновите Dockerfile:
`nano /root/myapp/Dockerfile`

2. Добавьте:
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
```

3. Обновите `app.sh` чтобы он показывал переменные:
`nano /root/myapp/app.sh`

```
#!/bin/bash
echo "App version: $APP_VERSION"
echo "Environment: $APP_ENV"
echo "Hostname: $(hostname)"
```
