# Поздравляем! 🎉

Вы успешно завершили модуль **«Docker: Тома и данные»**!

## Что вы освоили

- **Проблема эфемерности** — данные в writable layer исчезают при `docker rm`
- **Named volumes** — управляемые Docker, переживают удаление контейнера
- **Bind mounts** — монтирование директорий хоста, флаг `:ro`
- **tmpfs** — данные в памяти, для секретов и временных файлов
- **`docker volume`** — create, ls, inspect, rm, prune

## Когда что использовать

| Ситуация | Тип |
|----------|-----|
| База данных | Named volume |
| Разработка (live reload) | Bind mount |
| Конфиги (read-only) | Bind mount `:ro` |
| Секреты, токены | tmpfs |
| CI/CD кеш | Named volume |

## Шпаргалка

| Команда | Описание |
|---------|----------|
| `docker volume create NAME` | Создать том |
| `docker volume ls` | Список томов |
| `docker volume inspect NAME` | Подробности |
| `docker volume rm NAME` | Удалить том |
| `docker volume prune` | Удалить неиспользуемые |
| `-v vol:/path` | Подключить том |
| `-v /host:/cont:ro` | Bind mount (read-only) |
| `--tmpfs /path` | tmpfs mount |

## Следующий шаг

В следующем модуле **«Сеть в Docker»** вы научитесь связывать контейнеры между собой!
