## Делаем snapshot в tar.xz

`xz` обычно сжимает сильнее, чем `gzip`, но работает медленнее.
Это полезно, когда важен размер архива.

Сделайте отдельный snapshot каталога `config`:

```bash
tar -cJf /root/config-snapshot.tar.xz -C /opt/archive-lab project/config
tar -tJf /root/config-snapshot.tar.xz > /root/config_snapshot_list.txt

cat /root/config_snapshot_list.txt
```{{execute}}

Ключ `-J` включает сжатие через `xz`.

Такой формат подходит для редких, но компактных backup-слепков.
