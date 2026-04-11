## Передаём список файлов в xargs

`xargs` помогает превратить поток строк в аргументы для другой команды.

Соберите имена конфигов из каталога:

```bash
find /opt/text-lab/configs -type f | xargs -n1 basename | sort > /root/config_names.txt
cat /root/config_names.txt
```{{execute}}

Это полезно, когда одна команда генерирует список файлов, а другая должна обработать каждый из них.
