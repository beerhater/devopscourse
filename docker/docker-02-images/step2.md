## Скачиваем образы (pull)

Команда `docker pull` скачивает образ в локальный кэш.
Без указания тега скачивается `latest`.

---

1. Скачайте последнюю версию Alpine Linux (самый маленький базовый образ, ~5MB):
`docker pull alpine`

2. Скачайте конкретную версию nginx:
`docker pull nginx:1.25-alpine`

3. Скачайте образ PostgreSQL:
`docker pull postgres:15`

4. Посмотрите что скачалось и обратите внимание на слои:
`docker images`
