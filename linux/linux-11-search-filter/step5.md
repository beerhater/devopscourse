## wc, sort и uniq

Теперь разберём простой паттерн анализа:
- `wc` — посчитать;
- `sort` — отсортировать;
- `uniq` — убрать дубликаты или посчитать повторы.

```bash
wc -l /opt/search-lab/ip-list.txt > /root/ip_count.txt
sort /opt/search-lab/ip-list.txt | uniq -c | sort -nr > /root/ip_stats.txt

cat /root/ip_count.txt
cat /root/ip_stats.txt
```{{execute}}

Такой приём часто используют:
- для поиска самых шумных IP;
- для анализа часто повторяющихся ошибок;
- для быстрой агрегации простых логов без Elasticsearch и Grafana.
