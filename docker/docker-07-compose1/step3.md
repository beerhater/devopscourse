## Запуск стека

Все команды `docker compose` выполняются из папки с `docker-compose.yml`.

- `docker compose up` — запустить (в foreground, видим логи)
- `docker compose up -d` — запустить в фоне (detached)
- `docker compose up --build` — пересобрать образы перед запуском

---

1. Перейдите в папку стека:
`cd /root/mystack`

2. Запустите стек в фоне:
`docker compose up -d`

3. Посмотрите запущенные сервисы:
`docker compose ps`

4. Убедитесь что web отвечает:
`curl http://localhost:8080`

5. Посмотрите все контейнеры:
`docker ps`

Обратите внимание на имена контейнеров — Compose добавляет префикс с именем папки.
