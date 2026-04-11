## Делаем backup в tar.gz

Чаще всего каталог сначала собирают через `tar`, а потом сразу сжимают через `gzip`.
Так получается привычный формат `tar.gz`.

```bash
tar -czf /root/project-backup.tar.gz -C /opt/archive-lab project
tar -tzf /root/project-backup.tar.gz
```{{execute}}

Запомните комбинацию:

- `-c` создать архив;
- `-z` сжать его через gzip;
- `-f` записать в файл;
- `-t` показать содержимое архива.

Это один из самых типичных backup-форматов на Linux-серверах.
