# Шаг 2: Именованные тома — docker volume

**Именованный том (named volume)** — это директория на хосте, которой управляет Docker. Том существует независимо от контейнеров и переживает их удаление.

## Создание тома

```bash
docker volume create my-data
```{{execute}}

## Список томов

```bash
docker volume ls
```{{execute}}

## Подробная информация о томе

```bash
docker volume inspect my-data
```{{execute}}

Обратите внимание на `Mountpoint` — это реальный путь на хосте, где Docker хранит данные тома (обычно `/var/lib/docker/volumes/...`).

## Создайте ещё несколько томов

```bash
docker volume create db-data
docker volume create app-logs
docker volume ls
```{{execute}}

## Используйте том с контейнером

```bash
docker run --rm -v my-data:/data alpine sh -c "echo 'Persistent!' > /data/test.txt"
```{{execute}}

Данные записаны в том. Проверьте, что они сохранились после удаления контейнера:

```bash
docker run --rm -v my-data:/data alpine cat /data/test.txt
```{{execute}}

Данные на месте — контейнер удалён, том жив!
