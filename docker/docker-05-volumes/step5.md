# Шаг 5: tmpfs — данные в памяти

**tmpfs mount** хранит данные в оперативной памяти хоста. Данные **не попадают на диск** и исчезают при остановке контейнера.

## Когда использовать tmpfs

- Секреты и временные токены, которые нельзя писать на диск
- Временные файлы для высокопроизводительных операций
- Кеши, которые не нужно сохранять

## Синтаксис

```
--tmpfs /container/path
--mount type=tmpfs,target=/container/path,tmpfs-size=100m
```

## Задание 1: Базовый tmpfs

```bash
docker run -d \
  --name tmpfs-demo \
  --tmpfs /tmp:size=50m \
  alpine sleep 120
```{{execute}}

```bash
docker exec tmpfs-demo sh -c "echo 'secret token' > /tmp/token.txt && cat /tmp/token.txt"
```{{execute}}

```bash
docker exec tmpfs-demo df -h /tmp
```{{execute}}

Видите тип файловой системы `tmpfs` — данные в памяти.

## Задание 2: Данные исчезают при рестарте

```bash
docker restart tmpfs-demo
docker exec tmpfs-demo cat /tmp/token.txt
```{{execute}}

Файл исчез — tmpfs очищается при рестарте контейнера.

## Сравнение типов монтирования

| Тип | Данные | Управление | Применение |
|-----|--------|-----------|------------|
| Volume | На диске (Docker) | Docker | Базы данных, постоянные данные |
| Bind mount | На диске (хост) | Вы | Разработка, конфиги |
| tmpfs | В памяти | Ядро ОС | Секреты, временные файлы |

```bash
docker stop tmpfs-demo && docker rm tmpfs-demo
```{{execute}}
