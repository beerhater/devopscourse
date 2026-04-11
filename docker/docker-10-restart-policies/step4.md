# Шаг 4: Политика always

Теперь посмотрим на контейнер с `always`.

```bash
docker rm -f restart-always 2>/dev/null || true
docker run -d --name restart-always --restart always nginx:alpine >/dev/null
sleep 2
docker inspect restart-always --format '{{.HostConfig.RestartPolicy.Name}}' > /root/restart_always_policy.txt
cat /root/restart_always_policy.txt
```{{execute}}

`always` агрессивнее, чем `unless-stopped`, и чаще встречается на старых standalone Docker host.
