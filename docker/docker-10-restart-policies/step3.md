# Шаг 3: Политика unless-stopped

Теперь создадим long-running контейнер с `unless-stopped`.

```bash
docker rm -f restart-unless 2>/dev/null || true
docker run -d --name restart-unless --restart unless-stopped nginx:alpine >/dev/null
sleep 2
docker inspect restart-unless --format '{{.HostConfig.RestartPolicy.Name}}' > /root/restart_unless_policy.txt
cat /root/restart_unless_policy.txt
```{{execute}}

Эта policy часто подходит для фоновых сервисов на обычном Docker host.
