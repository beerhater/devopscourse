## COPY и ADD — файлы в образ

`COPY` — копирует файлы с хоста в образ. Использовать по умолчанию.
`ADD` — как COPY, но умеет распаковывать `.tar.gz` и скачивать по URL.
Рекомендация: используйте COPY — она предсказуема и явна.

`WORKDIR` — задаёт рабочую директорию. Если не существует — создаётся автоматически.

---

1. Создайте файл приложения:
`nano /root/myapp/app.sh`

2. Вставьте:
```
#!/bin/bash
echo "Hello from container!"
echo "Hostname: $(hostname)"
date
```

3. Обновите Dockerfile:
`nano /root/myapp/Dockerfile`

4. Добавьте строки:
```
FROM ubuntu:22.04

RUN apt-get update && \
    apt-get install -y curl wget && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY app.sh /app/app.sh
RUN chmod +x /app/app.sh
```

Сохраните файл.
