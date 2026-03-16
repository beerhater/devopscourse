## Масштабирование

Compose умеет запускать несколько реплик одного сервиса.
Это полезно для stateless-сервисов (веб-серверы, worker-процессы).

Важно: у масштабируемого сервиса не должен быть явный порт (`ports`),
иначе несколько реплик не смогут привязаться к одному порту хоста.

---

1. Запустите стек:
`cd /root/prodstack && docker compose up -d`

2. Подождите пока db и cache станут healthy:
`docker compose ps`

3. Проверьте статус app:
`docker compose ps app`

4. Масштабируйте app до 3 реплик:
`docker compose up -d --scale app=3`

5. Посмотрите что запустилось:
`docker compose ps`

6. Уменьшите обратно до 1:
`docker compose up -d --scale app=1`
