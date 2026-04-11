# Шаг 3: Ограничиваем число процессов

Кроме CPU и памяти, контейнеру полезно ограничивать и количество процессов.

```bash
docker rm -f pids-demo 2>/dev/null || true
docker run -d --name pids-demo --pids-limit 50 nginx:alpine >/dev/null
sleep 2
docker inspect pids-demo --format '{{.HostConfig.PidsLimit}}' > /root/resource_pids_limit.txt
cat /root/resource_pids_limit.txt
```{{execute}}
