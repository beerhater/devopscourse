# Шаг 4: Создаём и находим лишний volume

Теперь сделаем то же самое с volume.

```bash
docker volume rm cleanup-vol 2>/dev/null || true
docker volume create cleanup-vol >/dev/null
docker volume ls --format '{{.Name}}' | grep '^cleanup-vol$' > /root/cleanup_volume_before.txt
cat /root/cleanup_volume_before.txt
```{{execute}}
