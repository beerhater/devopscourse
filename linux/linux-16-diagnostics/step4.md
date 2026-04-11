## Смотрим usage по каталогам

Теперь создадим небольшой учебный каталог и посмотрим, какая его часть занимает больше всего места.

```bash
mkdir -p /opt/diagnostics-lab/{logs,backups,images}

truncate -s 1M /opt/diagnostics-lab/logs/app.log
truncate -s 8M /opt/diagnostics-lab/backups/db.dump
truncate -s 12M /opt/diagnostics-lab/images/cache.tar

du -sh /opt/diagnostics-lab/* | sort -h > /root/du_report.txt
cat /root/du_report.txt
```{{execute}}

`du -sh` показывает размер по каталогам, а `sort -h` помогает быстро увидеть лидеров по объёму.
