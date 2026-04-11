## Восстанавливаем один файл из архива

В реальной работе часто не нужно распаковывать весь backup.
Достаточно вернуть один конфиг.

Восстановите только `app.env` из `project-backup.tar.gz` прямо в новый файл:

```bash
tar -xzf /root/project-backup.tar.gz -O project/config/app.env > /root/recovered_app.env

cat /root/recovered_app.env
```{{execute}}

Флаг `-O` отправляет содержимое файла в stdout.
Это очень удобно, когда нужно быстро вытащить один файл и не засорять каталог распаковкой всего архива.
