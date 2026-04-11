## Сжимаем один файл через gzip

`gzip` обычно применяют для одиночных файлов, чаще всего логов.

Сожмите лог и сразу восстановите его содержимое в отдельный файл:

```bash
cp /opt/archive-lab/project/logs/app.log /root/app.log

gzip -k /root/app.log
gunzip -c /root/app.log.gz > /root/app.log.restored

ls -lh /root/app.log /root/app.log.gz
cat /root/app.log.restored
```{{execute}}

Что делают ключи:

- `-k` оставляет исходный файл на месте;
- `gunzip -c` печатает содержимое в stdout, не удаляя архив.

Это удобно, когда надо быстро заглянуть внутрь `.gz`, не меняя исходный артефакт.
