# Шаг 3: Создаём и находим лишнюю сеть

Сначала создадим сеть, которая нигде не используется, и найдём её в списке.

```bash
docker network rm cleanup-net 2>/dev/null || true
docker network create cleanup-net >/dev/null
docker network ls --format '{{.Name}}' | grep '^cleanup-net$' > /root/cleanup_network_before.txt
cat /root/cleanup_network_before.txt
```{{execute}}
