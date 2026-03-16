# Шаг 4: Связь контейнеров по имени (DNS)

В пользовательской bridge-сети Docker автоматически настраивает **встроенный DNS-сервер**. Каждый контейнер получает DNS-запись по своему имени и всем псевдонимам.

## Задание 1: Проверьте DNS по имени

Запустите тестовый контейнер в той же сети:

```bash
docker run --rm --network app-network alpine nslookup web
```{{execute}}

Docker резолвит имя `web` в IP-адрес контейнера!

## Задание 2: Пинг по имени

```bash
docker run --rm --network app-network alpine ping -c 3 web
```{{execute}}

```bash
docker run --rm --network app-network alpine ping -c 3 cache
```{{execute}}

## Задание 3: Реальный запрос к nginx по имени

```bash
docker run --rm --network app-network alpine wget -qO- http://web
```{{execute}}

## Псевдонимы (network aliases)

Один контейнер может иметь несколько DNS-имён:

```bash
docker run -d \
  --name db-primary \
  --network app-network \
  --network-alias database \
  --network-alias db \
  postgres:15-alpine \
  -c "postgres_password=secret"
```{{execute}}

```bash
docker run --rm --network app-network alpine nslookup database
docker run --rm --network app-network alpine nslookup db
```{{execute}}

Оба имени резолвятся в один контейнер!
