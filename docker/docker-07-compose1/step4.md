## Логи и статус

---

1. Посмотрите логи всех сервисов:
`docker compose logs`

2. Логи конкретного сервиса:
`docker compose logs db`

3. Следите за логами в реальном времени:
`docker compose logs -f web`

Нажмите `Ctrl+C` чтобы выйти.

4. Посмотрите статус сервисов:
`docker compose ps`

5. Посмотрите использование ресурсов контейнерами стека:
`docker stats --no-stream $(docker compose ps -q)`
