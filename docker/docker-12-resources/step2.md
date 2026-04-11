# Шаг 2: Читаем limits через inspect

Теперь вытащим ресурсные настройки контейнера отдельно и в более читаемом виде.

```bash
docker inspect resource-demo --format 'memory={{.HostConfig.Memory}} nanocpus={{.HostConfig.NanoCpus}}' > /root/resource_limits_detailed.txt
cat /root/resource_limits_detailed.txt
```{{execute}}
