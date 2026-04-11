# Шаг 1: Ищем мусор и убираем его

Создайте stopped container, соберите audit и затем удалите его.

```bash
docker rm -f cleanup-demo 2>/dev/null || true

docker create --name cleanup-demo alpine sh -c 'echo temp'
docker ps -a --filter status=created --format '{{.Names}}' > /root/cleanup_before.txt
docker image prune -f >/root/docker_prune_output.txt 2>&1 || true
docker rm cleanup-demo >/dev/null
docker ps -a --filter name=cleanup-demo --format '{{.Names}}' > /root/cleanup_after.txt

cat /root/cleanup_before.txt
cat /root/cleanup_after.txt
```{{execute}}

Идея здесь простая:

- сначала собрать картину;
- потом удалить только понятный мусор;
- не использовать разрушительные команды вслепую.
