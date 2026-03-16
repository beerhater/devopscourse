# Шаг 2: Структура docker-compose.yml

## Создайте рабочую директорию

```bash
mkdir -p /opt/compose-intro && cd /opt/compose-intro
```{{execute}}

## Создайте базовый файл

```bash
cat > docker-compose.yml << 'COMPOSEFILE'
services:
  web:
    image: nginx:alpine
    container_name: my-web
    ports:
      - "8080:80"
    restart: unless-stopped

  app:
    image: alpine
    command: sh -c "while true; do echo 'App running'; sleep 5; done"
    depends_on:
      - web
COMPOSEFILE
```{{execute}}

```bash
cat docker-compose.yml
```{{execute}}

## Ключевые поля сервиса

| Поле | Описание |
|------|----------|
| `image` | Образ Docker Hub |
| `build` | Путь к Dockerfile (вместо image) |
| `ports` | Проброс портов `host:container` |
| `environment` | Переменные окружения |
| `volumes` | Монтирование томов |
| `networks` | Подключение к сетям |
| `depends_on` | Зависимости от других сервисов |
| `restart` | Политика рестарта: `no`, `always`, `unless-stopped`, `on-failure` |
| `command` | Переопределение CMD образа |
