# Шаг 3: Просмотр образов — docker images

`docker images` показывает все локальные образы.

## Основные варианты команды

Полный список с деталями:

```bash
docker images
```{{execute}}

Столбцы таблицы:
| Столбец | Описание |
|---------|----------|
| REPOSITORY | Имя образа |
| TAG | Версия/тег |
| IMAGE ID | Уникальный ID (сокращённый) |
| CREATED | Когда создан |
| SIZE | Размер на диске |

## Только имена и теги

```bash
docker images --format "{{.Repository}}:{{.Tag}}"
```{{execute}}

## Только ID образов

```bash
docker images -q
```{{execute}}

## Фильтрация по имени

```bash
docker images nginx
```{{execute}}

## Размер всех образов суммарно

```bash
docker system df
```{{execute}}

Команда `docker system df` показывает сводку по использованию диска: образы, контейнеры, volumes.
