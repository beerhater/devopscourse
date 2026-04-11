## Достаём поля и считаем через awk

`awk` силён там, где нужно:

- брать нужные колонки;
- фильтровать строки;
- считать суммы и простые метрики.

Сформируйте короткий отчёт по памяти сервисов и посчитайте общий CPU budget:

```bash
awk 'NR > 1 {print $1, $3}' /opt/text-lab/resources.tsv > /root/service_memory.txt
awk 'NR > 1 {sum += $2} END {print sum}' /opt/text-lab/resources.tsv > /root/total_cpu.txt

cat /root/service_memory.txt
cat /root/total_cpu.txt
```{{execute}}

В результате у вас будет:

- список сервисов и их памяти;
- сумма CPU по всем сервисам.

Это уже похоже на маленький capacity review.
