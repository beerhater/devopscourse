## Итоговая мини-диагностика

Соберём типичную DevOps-цепочку:
1. найти все лог-файлы;
2. понять сколько в них ошибок.

```bash
find /opt/search-lab/services -type f -name "*.log" | sort > /root/log_files.txt
grep -ri "error" /opt/search-lab/services | wc -l > /root/error_count.txt

cat /root/log_files.txt
cat /root/error_count.txt
```{{execute}}

Это маленький, но очень реальный шаблон:
`find` помогает найти данные, `grep` — выделить сигнал, `wc` — быстро оценить масштаб проблемы.
