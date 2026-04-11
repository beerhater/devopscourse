# Шаг 3: Сохраняем startup-логи

Логи часто дают самый быстрый ответ на вопрос “что происходит”.

```bash
docker logs inspect-demo > /root/inspect_startup_logs.txt 2>&1
cat /root/inspect_startup_logs.txt
```{{execute}}

Даже если контейнер уже “запущен”, startup-логи часто помогают увидеть предупреждения, ошибки и признаки неверной конфигурации.
