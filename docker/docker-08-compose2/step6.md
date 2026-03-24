# Шаг 6: Override-файлы и окружения

Дублировать `docker-compose.yml` для dev и prod — плохо. Compose поддерживает **override-файлы**: базовый конфиг + патч для каждого окружения.

## Как работает merge

1. `docker-compose.yml` — базовая конфигурация
2. `docker-compose.override.yml` — применяется **автоматически** (обычно dev)
3. Prod: `docker compose -f docker-compose.yml -f docker-compose.prod.yml up`

```bash
cd /opt/compose2
```{{execute}}

**Базовый файл:**
```bash
cat > docker-compose.yml << 'COMPOSEFILE'
services:
  app:
    build: ./app
    environment:
      APP_VERSION: ${APP_VERSION:-dev}
    restart: unless-stopped

  redis:
    image: redis:alpine
    restart: unless-stopped

  db:
    image: postgres:15-alpine
    environment:
      POSTGRES_PASSWORD: ${DB_PASSWORD:-secret}
    volumes:
      - db-data:/var/lib/postgresql/data
    restart: unless-stopped

volumes:
  db-data:
COMPOSEFILE
```{{execute}}

**Dev override (применяется автоматически):**
```bash
cat > docker-compose.override.yml << 'COMPOSEFILE'
services:
  app:
    ports:
      - "5000:5000"
    environment:
      APP_ENV: development
    volumes:
      - ./app:/app

  db:
    ports:
      - "5432:5432"

  adminer:
    image: adminer
    ports:
      - "8081:8080"
COMPOSEFILE
```{{execute}}

**Prod конфиг:**
```bash
cat > docker-compose.prod.yml << 'COMPOSEFILE'
services:
  app:
    environment:
      APP_ENV: production
COMPOSEFILE
```{{execute}}

Dev — override применяется автоматически:
```bash
docker compose config | grep APP_ENV
```{{execute}}

Prod — явно указываем файлы:
```bash
docker compose -f docker-compose.yml -f docker-compose.prod.yml config | grep APP_ENV
```{{execute}}

```bash
docker compose down -v
```{{execute}}
