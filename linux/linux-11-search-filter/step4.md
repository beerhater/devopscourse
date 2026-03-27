## find по имени и типу

`find` нужен, когда вы знаете что ищете, но не знаете где именно это лежит.

```bash
find /opt/search-lab -type f -name "*.conf" | sort > /root/conf_files.txt
find /opt/search-lab -type d -name "archive" | sort > /root/archive_dirs.txt

cat /root/conf_files.txt
cat /root/archive_dirs.txt
```{{execute}}

Полезно запомнить:
- `-type f` — только файлы;
- `-type d` — только директории;
- `-name "*.conf"` — поиск по имени.

Это помогает быстро находить конфиги, backup-каталоги и артефакты старых деплоев.
