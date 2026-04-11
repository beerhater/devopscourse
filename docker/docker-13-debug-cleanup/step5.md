# Шаг 5: Удаляем неиспользуемую сеть

Когда вы уверены, что сеть не нужна, её можно убрать.

```bash
docker network rm cleanup-net >/dev/null
docker network ls --format '{{.Name}}' | grep '^cleanup-net$' > /root/cleanup_network_after.txt || true
cat /root/cleanup_network_after.txt
```{{execute}}
