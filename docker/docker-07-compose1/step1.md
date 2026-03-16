## Зачем нужен Compose

Посмотрим на разницу "без Compose" и "с Compose".

---

**Без Compose — 6 команд:**
```
docker network create app-net
docker volume create pgdata
docker run -d --name db --network app-net \
  -e POSTGRES_PASSWORD=secret -v pgdata:/var/lib/postgresql/data postgres:15
docker run -d --name cache --network app-net redis:7
docker run -d --name app --network app-net -p 8080:80 mynginx
```

**С Compose — 1 команда:**
```
docker compose up -d
```

---

1. Убедитесь что Docker Compose установлен:
`docker compose version`

2. Сохраните версию:
`docker compose version > /root/compose_version.txt`
