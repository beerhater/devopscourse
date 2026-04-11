# Шаг 6: Удаляем неиспользуемый volume

Теперь удалим volume.

```bash
docker volume rm cleanup-vol >/dev/null
docker volume ls --format '{{.Name}}' | grep '^cleanup-vol$' > /root/cleanup_volume_after.txt || true
cat /root/cleanup_volume_after.txt
```{{execute}}
