# Шаг 3: Запуск стека — docker-compose up

## Основные команды

| Команда | Описание |
|---------|----------|
| `docker-compose up` | Запуск в foreground (видны логи) |
| `docker-compose up -d` | Запуск в фоне (detached) |
| `docker-compose down` | Остановка и удаление контейнеров/сетей |
| `docker-compose down -v` | Также удалить тома |

## Задание 1: Запустите стек

```bash
cd /opt/compose-intro && docker-compose up -d
```{{execute}}

Compose автоматически:
1. Создаёт сеть `compose-intro_default`
2. Запускает сервисы с учётом `depends_on`
3. Именует контейнеры как `<project>_<service>_<номер>`

```bash
docker-compose ps
```{{execute}}

## Задание 2: Проверьте созданную сеть

```bash
docker network ls | grep compose
```{{execute}}

## Задание 3: Проверьте nginx

```bash
curl http://localhost:8080
```{{execute}}

## Задание 4: Остановите стек

```bash
docker-compose down
```{{execute}}

`down` удаляет контейнеры и сети. Данные в томах **сохраняются** — нужен `down -v` для их удаления.
