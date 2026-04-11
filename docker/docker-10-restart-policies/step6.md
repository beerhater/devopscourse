# Шаг 6: Читаем логи после сбоя

Когда контейнер падает, полезно посмотреть, что он успел записать перед завершением.

```bash
docker logs restart-demo > /root/restart_demo_logs_detailed.txt 2>&1
cat /root/restart_demo_logs_detailed.txt
```{{execute}}

Даже если policy всё поднимет заново, без логов вы не поймёте реальную причину сбоя.
