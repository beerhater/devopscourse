# Шаг 1: CPU и memory limits

Запустите контейнер с ограничениями по CPU и памяти и сохраните отчёт через `inspect`.

```bash
docker rm -f resource-demo 2>/dev/null || true

docker run -d --name resource-demo --memory 128m --cpus 0.5 nginx:alpine >/dev/null
sleep 3

docker inspect resource-demo --format 'Memory={{.HostConfig.Memory}} NanoCpus={{.HostConfig.NanoCpus}}' > /root/resource_limits.txt
docker ps --filter name=resource-demo --format '{{.Names}} {{.Status}}' > /root/resource_status.txt

cat /root/resource_limits.txt
```{{execute}}

Почему это важно:

- лимиты помогают не положить host одной ошибкой;
- это базовая дисциплина перед переходом к Kubernetes requests/limits.
