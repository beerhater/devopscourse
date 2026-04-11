# Шаг 4: Заходим внутрь контейнера через exec

Теперь заглянем внутрь контейнера и убедимся, что конфиг nginx действительно лежит на месте.

```bash
docker exec inspect-demo sh -c 'id && ls /etc/nginx && head -n 3 /etc/nginx/nginx.conf' > /root/inspect_inside.txt
cat /root/inspect_inside.txt
```{{execute}}

`docker exec` особенно полезен, когда нужно быстро проверить:

- пользователя процесса;
- наличие файлов;
- содержимое ключевых конфигов.
