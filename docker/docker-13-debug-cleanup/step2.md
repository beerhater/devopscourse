# Шаг 2: Снимаем docker system df

Перед cleanup полезно понять, сколько места вообще занимают Docker-артефакты.

```bash
docker system df > /root/docker_system_df.txt
cat /root/docker_system_df.txt
```{{execute}}
