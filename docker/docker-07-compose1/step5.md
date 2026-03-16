# Шаг 5: Сети и тома в Compose

Compose создаёт сеть автоматически, но вы можете задать явные сети и тома.

## Остановите текущий стек

```bash
cd /opt/compose-intro && docker-compose down
```{{execute}}

## Создайте расширенный docker-compose.yml

```bash
cat > docker-compose.yml << 'COMPOSEFILE'
services:
  web:
    image: nginx:alpine
    ports:
      - "8080:80"
    networks:
      - frontend
    volumes:
      - web-logs:/var/log/nginx

  db:
    image: postgres:15-alpine
    environment:
      POSTGRES_PASSWORD: secret
      POSTGRES_DB: appdb
    volumes:
      - db-data:/var/lib/postgresql/data
    networks:
      - backend

  adminer:
    image: adminer
    ports:
      - "8081:8080"
    networks:
      - frontend
      - backend
    depends_on:
      - db

networks:
  frontend:
    driver: bridge
  backend:
    driver: bridge
    internal: true

volumes:
  db-data:
  web-logs:
COMPOSEFILE
```{{execute}}

```bash
docker-compose up -d
```{{execute}}

## Проверьте изоляцию сетей

web не видит db (разные сети):
```bash
docker-compose exec web ping -c 1 db || echo "Изоляция работает!"
```{{execute}}

adminer видит db (состоит в обеих сетях):
```bash
docker-compose exec adminer ping -c 1 db
```{{execute}}

## Проверьте тома

```bash
docker volume ls | grep compose
```{{execute}}
