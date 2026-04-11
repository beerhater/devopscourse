# Шаг 6: Собираем единый ресурсный отчёт

Сведите все ограничения в один файл:

```bash
{
  echo "$(cat /root/resource_limits_detailed.txt)"
  echo "pids=$(cat /root/resource_pids_limit.txt)"
  echo "nofile=$(cat /root/resource_nofile_limit.txt)"
} > /root/resource_final_limits.txt

cat /root/resource_final_limits.txt
```{{execute}}
