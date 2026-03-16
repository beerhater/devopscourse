## Остановка и очистка (down)

- `docker compose stop` — остановить контейнеры, но не удалять
- `docker compose down` — остановить и удалить контейнеры + сети
- `docker compose down -v` — также удалить тома (ОСТОРОЖНО: потеря данных!)

---

1. Остановите стек без удаления:
`docker compose stop`

2. Убедитесь что контейнеры остановлены:
`docker compose ps`

3. Снова запустите:
`docker compose start`

4. Теперь полностью удалите стек (без томов):
`docker compose down`

5. Убедитесь что том pgdata сохранился:
`docker volume ls | grep pgdata`

6. Если хотите удалить всё включая тома:
`docker compose down -v`
