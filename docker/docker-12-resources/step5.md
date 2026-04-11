# Шаг 5: Смотрим docker stats

Теперь снимем живую сводку по использованию ресурсов.

```bash
docker stats --no-stream --format '{{.Name}} {{.CPUPerc}} {{.MemUsage}}' resource-demo > /root/resource_stats.txt
cat /root/resource_stats.txt
```{{execute}}

`inspect` показывает конфигурацию, а `docker stats` — текущее потребление.
