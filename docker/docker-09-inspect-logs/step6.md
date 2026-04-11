# Шаг 6: Проверяем HTTP-ответ сервиса

Теперь проверим сервис уже глазами клиента.

```bash
curl -s http://localhost:8091 | head -n 2 > /root/inspect_http.txt
cat /root/inspect_http.txt
```{{execute}}

Это маленький, но важный шаг: контейнер может работать, а HTTP-ответ уже покажет, отдаёт ли он контент вообще.
