# Шаг 4: Добавляем ulimit nofile

Ещё один частый лимит для сервисов с большим числом соединений — `nofile`.

```bash
docker rm -f nofile-demo 2>/dev/null || true
docker run -d --name nofile-demo --ulimit nofile=1024:1024 nginx:alpine >/dev/null
sleep 2
docker inspect nofile-demo --format '{{json .HostConfig.Ulimits}}' > /root/resource_nofile_limit.txt
cat /root/resource_nofile_limit.txt
```{{execute}}
