# Шаг 6: Сравниваем два типа сбоев

Сведите два сбоя в одну таблицу:

```bash
{
  echo "broken-demo $(cat /root/broken_reason_jsonpath.txt)"
  echo "crash-demo $(cat /root/crash_reason.txt)"
} > /root/troubleshooting_compare.txt

cat /root/troubleshooting_compare.txt
```{{execute}}
