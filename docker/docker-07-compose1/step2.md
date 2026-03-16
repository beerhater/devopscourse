## Структура docker-compose.yml

---

1. Создайте рабочую папку:
`mkdir -p /root/mystack && cd /root/mystack`

2. Создайте файл:
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
    volumes:
      - pgdata:/var/lib/postgresql/data

  cache:
    image: redis:7-alpine

  web:
    image: nginx:alpine
    ports:
      - "8080:80"
    volumes:
      - ./html:/usr/share/nginx/html

volumes:
  pgdata:
```

4. Создайте папку для html:
`mkdir -p /root/mystack/html`
`echo "<h1>Hello from Compose!</h1>" > /root/mystack/html/index.html`
