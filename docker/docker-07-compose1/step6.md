# Шаг 6: Переменные окружения и .env файл

Хранить пароли в `docker-compose.yml` — плохая практика. Используйте `.env` файлы.

## Остановите стек

```bash
cd /opt/compose-intro && docker-compose down -v
```{{execute}}

## Создайте .env файл

```bash
cat > .env << 'ENVFILE'
POSTGRES_PASSWORD=supersecret
POSTGRES_DB=myapp
POSTGRES_USER=appuser
WEB_PORT=8080
ADMINER_PORT=8081
APP_ENV=development
ENVFILE
```{{execute}}

## Используйте переменные в docker-compose.yml

```bash
cat > docker-compose.yml << 'COMPOSEFILE'
services:
  web:
    image: nginx:alpine
    ports:
      - "${WEB_PORT}:80"
    environment:
      - APP_ENV=${APP_ENV}

  db:
    image: postgres:15-alpine
    environment:
      POSTGRES_PASSWORD: ${POSTGRES_PASSWORD}
      POSTGRES_DB: ${POSTGRES_DB}
      POSTGRES_USER: ${POSTGRES_USER}
    volumes:
      - db-data:/var/lib/postgresql/data

  adminer:
    image: adminer
    ports:
      - "${ADMINER_PORT}:8080"
    depends_on:
      - db

volumes:
  db-data:
COMPOSEFILE
```{{execute}}

Проверьте итоговый конфиг с подставленными переменными:
```bash
docker-compose config
```{{execute}}

```bash
docker-compose up -d
docker-compose exec db env | grep POSTGRES
```{{execute}}
