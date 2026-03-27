## Входной поток через <

Символ `<` подаёт файл на вход команде.
Это удобно, когда команда умеет читать данные из stdin.

```bash
wc -l < /opt/pipes-lab/services.txt > /root/services_count.txt
sort < /opt/pipes-lab/services.txt > /root/services_sorted.txt

cat /root/services_count.txt
cat /root/services_sorted.txt
```{{execute}}

Здесь:
- `wc -l` посчитал сколько сервисов в списке;
- `sort` отсортировал список по алфавиту.

Такой стиль часто встречается в shell automation и cron-задачах.
