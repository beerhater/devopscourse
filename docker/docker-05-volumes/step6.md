# Шаг 6: Управление томами — inspect, rm, prune

## Просмотр всех томов

```bash
docker volume ls
```{{execute}}

## Детальная информация

```bash
docker volume inspect my-data
```{{execute}}

Полезные поля:
- `Mountpoint` — путь на хосте
- `CreatedAt` — когда создан
- `Labels` — метки

## Удаление конкретного тома

```bash
docker volume rm app-logs
```{{execute}}

Нельзя удалить том, который используется контейнером — Docker выдаст ошибку.

## Очистка неиспользуемых томов

```bash
docker volume prune
```{{execute}}

`prune` удаляет все тома, к которым не подключён ни один контейнер. Подтвердите `y`.

## Создание тома с метками

```bash
docker volume create \
  --label project=myapp \
  --label env=production \
  prod-data
```{{execute}}

```bash
docker volume inspect prod-data
```{{execute}}

## Копирование данных между томами

```bash
docker volume create vol-source
docker volume create vol-dest

docker run --rm \
  -v vol-source:/source \
  -v vol-dest:/dest \
  alpine sh -c "echo 'data to copy' > /source/file.txt && cp -r /source/. /dest/"

docker run --rm -v vol-dest:/dest alpine cat /dest/file.txt
```{{execute}}
