# Поздравляем! 🎉

Вы успешно завершили модуль **«Docker Compose: Часть 1»**!

## Что вы освоили

- **`docker compose up/down`** — запуск и полная очистка стека
- **`docker-compose.yml`** — структура: `services`, `networks`, `volumes`
- **`docker compose ps/logs/exec`** — мониторинг и отладка
- **Сети** — автосеть, `internal: true` для изоляции backend
- **Тома** — именованные тома, переживают `down`
- **`.env` файлы** — вынос конфигурации и паролей
- **`docker compose config`** — проверка итогового конфига

## Шпаргалка

| Команда | Описание |
|---------|----------|
| `docker compose up -d` | Запустить в фоне |
| `docker compose down` | Остановить и удалить |
| `docker compose down -v` | + удалить тома |
| `docker compose ps` | Статус сервисов |
| `docker compose logs -f SVC` | Логи в реальном времени |
| `docker compose exec SVC CMD` | Команда в сервисе |
| `docker compose config` | Итоговый конфиг |
| `docker compose build` | Собрать образы |

## Следующий шаг

В следующем модуле **«Docker Compose: Часть 2»** — `healthcheck`, масштабирование и профили!
