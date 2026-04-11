# Шаг 2: Читаем образ и команду через inspect

`docker inspect` помогает быстро вытащить из контейнера технические детали без догадок.

```bash
docker inspect inspect-demo --format 'Image={{.Config.Image}} Cmd={{json .Config.Cmd}}' > /root/inspect_image_info.txt
cat /root/inspect_image_info.txt
```{{execute}}

Это полезно, когда нужно понять:

- какой образ реально запущен;
- какая команда стартует внутри контейнера;
- не отличается ли runtime от того, что вы ожидали.
