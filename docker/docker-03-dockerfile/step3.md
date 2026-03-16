# Шаг 3: Инструкции COPY и ADD

## COPY — копирование файлов в образ

`COPY` копирует файлы и директории с хоста в образ:

```
COPY <src> <dest>
```

## Задание: создайте приложение с файлами

```bash
cd /opt/myapp
```{{execute}}

Создайте простой скрипт:

```bash
cat > hello.sh << 'SCRIPT'
#!/bin/bash
echo "==============================="
echo "  Hello from Docker container!"
echo "  Hostname: $(hostname)"
echo "  Date: $(date)"
echo "==============================="
SCRIPT
```{{execute}}

Создайте файл конфигурации:

```bash
cat > config.txt << 'CONFIG'
APP_NAME=MyDockerApp
VERSION=1.0
ENVIRONMENT=production
CONFIG
```{{execute}}

Напишите Dockerfile с `COPY`:

```bash
cat > Dockerfile << 'DOCKERFILE'
FROM alpine:3.18

RUN apk add --no-cache bash

# Копируем один файл
COPY hello.sh /app/hello.sh

# Копируем файл конфигурации
COPY config.txt /app/config.txt

# Делаем скрипт исполняемым
RUN chmod +x /app/hello.sh

CMD ["/app/hello.sh"]
DOCKERFILE
```{{execute}}

```bash
docker build -t my-copy-app .
docker run --rm my-copy-app
```{{execute}}

## ADD vs COPY

`ADD` умеет то же, что `COPY`, плюс:
- Автоматически распаковывает `.tar` архивы
- Может скачивать файлы по URL

**Правило:** используйте `COPY` если не нужны функции `ADD`.
