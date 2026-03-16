# Шаг 7: Итоговое задание

Соберём приложение, демонстрирующее все три типа монтирования.

**1. Создайте том и приложение:**

```bash
docker volume create app-storage
mkdir -p /opt/app-config
```{{execute}}

```bash
cat > /opt/app-config/settings.env << 'ENV'
DB_HOST=localhost
LOG_LEVEL=info
MAX_CONNECTIONS=100
ENV
```{{execute}}

**2. Запустите контейнер со всеми типами монтирования:**

```bash
docker run -d \
  --name full-demo \
  -v app-storage:/app/data \
  -v /opt/app-config:/app/config:ro \
  --tmpfs /app/tmp:size=10m \
  alpine sleep 300
```{{execute}}

**3. Запишите данные в каждое хранилище:**

```bash
docker exec full-demo sh -c "echo 'persistent data' > /app/data/record.txt"
docker exec full-demo sh -c "echo 'temp cache' > /app/tmp/cache.tmp"
```{{execute}}

**4. Проверьте конфиг (bind mount, read-only):**

```bash
docker exec full-demo cat /app/config/settings.env
```{{execute}}

**5. Убедитесь, что нельзя писать в ro bind mount:**

```bash
docker exec full-demo sh -c "echo 'hack' >> /app/config/settings.env" || echo "Запись запрещена — всё верно!"
```{{execute}}

**6. Проверьте персистентность тома — пересоздайте контейнер:**

```bash
docker stop full-demo && docker rm full-demo
docker run --rm -v app-storage:/app/data alpine cat /app/data/record.txt
```{{execute}}

Данные из тома сохранились!

**7. Очистите ресурсы:**

```bash
docker stop postgres-db2 2>/dev/null || true
docker rm postgres-db2 2>/dev/null || true
docker volume rm app-storage pg-data prod-data my-data db-data vol-source vol-dest 2>/dev/null || true
docker volume ls
```{{execute}}
