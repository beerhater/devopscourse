# Поздравляем! 🎉

Вы успешно завершили модуль **«Docker Compose: Часть 2»** и весь курс по Docker!

## Что вы освоили

- **`depends_on` + `condition`** — ждать `service_healthy`
- **`healthcheck`** — `test`, `interval`, `timeout`, `retries`, `start_period`
- **`build`** в Compose — `context`, `args`, `target`, флаг `--build`
- **`--scale`** — несколько реплик, `expose` вместо `ports`
- **`profiles`** — опциональные сервисы dev/tools
- **Override-файлы** — `override.yml` для dev, `-f` для prod

## Шпаргалка

| Команда | Описание |
|---------|----------|
| `docker compose up -d --build` | Собрать и запустить |
| `docker compose up --scale svc=3` | 3 реплики |
| `docker compose --profile dev up` | Запуск с профилем |
| `docker compose -f base.yml -f prod.yml up` | Объединить файлы |
| `docker compose config` | Итоговый конфиг |
| `docker compose ps` | Статус + healthcheck |
| `docker compose down -v` | Удалить + тома |

## Весь курс Docker пройден!

| Модуль | Тема |
|--------|------|
| 01 | Первые шаги: `run`, `ps`, `stop`, `rm` |
| 02 | Образы: `pull`, `images`, `rmi`, Docker Hub |
| 03 | Dockerfile: `FROM`, `RUN`, `COPY`, `CMD` |
| 04 | Сборка и публикация: `build`, `tag`, `push` |
| 05 | Тома: volumes, bind mounts, tmpfs |
| 06 | Сеть: bridge, host, DNS, `network create` |
| 07 | Compose ч.1: структура, `up/down`, `.env` |
| 08 | Compose ч.2: healthcheck, scale, profiles |
