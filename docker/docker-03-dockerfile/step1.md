# Шаг 1: Что такое Dockerfile

**Dockerfile** — это рецепт создания образа. Docker читает его сверху вниз и выполняет каждую инструкцию последовательно, создавая слой за слоем.

## Создайте рабочую директорию

```bash
mkdir -p /opt/myapp && cd /opt/myapp
```{{execute}}

## Напишите первый Dockerfile

```bash
cat > Dockerfile << 'DOCKERFILE'
# Базовый образ
FROM ubuntu:22.04

# Метаданные
LABEL maintainer="student@example.com"
LABEL version="1.0"

# Обновляем пакеты и ставим curl
RUN apt-get update && apt-get install -y curl

# Команда по умолчанию
CMD ["echo", "Hello from my first Docker image!"]
DOCKERFILE
```{{execute}}

## Изучите структуру

```bash
cat Dockerfile
```{{execute}}

Каждая строка — это **инструкция**: `ИНСТРУКЦИЯ аргументы`. Комментарии начинаются с `#`.

## Соберите образ

```bash
docker build -t my-first-image .
```{{execute}}

Флаг `-t` задаёт имя образа, `.` указывает на директорию с Dockerfile.

```bash
docker images my-first-image
```{{execute}}
