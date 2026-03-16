## depends_on — порядок запуска

`depends_on` говорит Compose: "Запусти этот сервис **после** указанного".

Важно: `depends_on` ждёт только **запуска контейнера**, не готовности приложения.
База данных может быть запущена, но ещё инициализироваться.
Для настоящего ожидания используется `healthcheck` (Шаг 3).

---

1. Создайте папку:
`mkdir -p /root/prodstack && cd /root/prodstack`

2. Создайте docker-compose.yml:
`nano docker-compose.yml`

3. Введите:
```yaml
version: "3.9"

services:
  db:
    image: postgres:15
    environment:
      POSTGRES_PASSWORD: secret
      POSTGRES_DB: appdb

  app:
    image: alpine
    command: sh -c "echo 'App started!' && sleep 300"
    depends_on:
      - db

  cache:
    image: redis:7-alpine
    depends_on:
      - db
```
