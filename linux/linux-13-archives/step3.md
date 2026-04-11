## Распаковываем архив

Теперь восстановим проект из архива в новую директорию.

```bash
rm -rf /root/restore-basic
mkdir -p /root/restore-basic

tar -xf /root/project.tar -C /root/restore-basic

find /root/restore-basic -maxdepth 3 -type f | sort
cat /root/restore-basic/project/config/app.env
```{{execute}}

Здесь:

- `-x` означает распаковать архив;
- `-f` указывает файл архива;
- `-C` задаёт директорию для восстановления.

Это ровно тот сценарий, который часто нужен после неудачной правки конфигов.
