# Шаг 2: Контейнер без restart policy

Сначала посмотрим на поведение контейнера без явно заданной policy.

```bash
docker rm -f restart-none 2>/dev/null || true
docker create --name restart-none alpine sh -c 'echo no-policy'
docker inspect restart-none --format '{{.HostConfig.RestartPolicy.Name}} {{.HostConfig.RestartPolicy.MaximumRetryCount}}' > /root/restart_none_policy.txt
cat /root/restart_none_policy.txt
```{{execute}}

Так вы видите baseline: что будет, если policy вообще не задавать.
