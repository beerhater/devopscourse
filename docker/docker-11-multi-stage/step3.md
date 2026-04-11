# Шаг 3: Проверяем runtime-содержимое

Теперь убедимся, что в runtime-слое остался только нужный артефакт.

```bash
docker exec multistage-demo ls -1 /app > /root/multistage_runtime_files.txt
cat /root/multistage_runtime_files.txt
```{{execute}}

Смысл multi-stage как раз в том, чтобы runtime был как можно чище.
