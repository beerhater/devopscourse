# Шаг 5: Поиск образов — Docker Hub

**Docker Hub** (hub.docker.com) — главный публичный реестр образов. Там миллионы образов от сообщества и официальных издателей.

## Поиск через командную строку

```bash
docker search nginx
```{{execute}}

Столбцы результата:
| Столбец | Описание |
|---------|----------|
| NAME | Имя образа |
| DESCRIPTION | Описание |
| STARS | Рейтинг (как звёзды на GitHub) |
| OFFICIAL | `[OK]` = официальный образ от Docker |
| AUTOMATED | Автоматическая сборка |

## Фильтрация: только официальные образы

```bash
docker search --filter is-official=true python
```{{execute}}

## Фильтрация по рейтингу

```bash
docker search --filter stars=100 redis
```{{execute}}

## Ограничение количества результатов

```bash
docker search --limit 5 postgres
```{{execute}}

## Задание

Найдите официальный образ `redis` и скачайте его:

```bash
docker search --filter is-official=true redis
docker pull redis:alpine
```{{execute}}

> **Совет:** На hub.docker.com можно смотреть все доступные теги образа, читать документацию и примеры использования — интерфейс удобнее, чем `docker search`.
