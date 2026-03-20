# Шаг 8: -m fetch и -m lineinfile

## -m fetch: скачиваем файлы С удалённого хоста

Противоположность copy: получаем файлы с управляемых узлов на управляющий.

```bash
cd ~/ansible-lab

# Скачать файл с удалённого хоста
ansible all -b -m fetch -a "src=/etc/hostname dest=/tmp/fetched/"
```{{execute}}

```bash
# Файл сохраняется как: dest/<имя_хоста>/путь_к_файлу
ls -la /tmp/fetched/
find /tmp/fetched -type f
cat /tmp/fetched/node01/etc/hostname
```{{execute}}

```bash
# flat=yes: без поддиректорий — сохранить файл напрямую
ansible all -b -m fetch -a "src=/etc/os-release dest=/tmp/node01-os-release flat=yes"
cat /tmp/node01-os-release | head -5
```{{execute}}

```bash
# Полезно: скачать логи для отладки
ansible all -b -m fetch -a "src=/var/log/auth.log dest=/tmp/logs/ flat=no" 2>/dev/null | head -3 || echo "Лог скачан"
```{{execute}}

## -m lineinfile: добавление/изменение строк в файлах

```bash
# Убедиться, что строка ПРИСУТСТВУЕТ в файле
ansible all -b -m lineinfile -a "path=/etc/hosts line='10.0.0.100 myapp.local' state=present"
```{{execute}}

```bash
ansible all -m shell -a "grep myapp /etc/hosts"
```{{execute}}

```bash
# Заменить строку по регулярному выражению
ansible all -b -m lineinfile -a "path=/etc/hosts regexp='myapp.local' line='10.0.0.200 myapp.local' state=present"
ansible all -m shell -a "grep myapp /etc/hosts"
```{{execute}}

```bash
# Удалить строку
ansible all -b -m lineinfile -a "path=/etc/hosts regexp='myapp.local' state=absent"
ansible all -m shell -a "grep myapp /etc/hosts || echo удалено"
```{{execute}}

## -m replace: замена по регулярному выражению во всём файле

```bash
# Создаём тестовый файл
ansible all -b -m copy -a "content='env=development
debug=true
port=8080
' dest=/tmp/app.cfg"
```{{execute}}

```bash
# Заменить все вхождения паттерна
ansible all -b -m replace -a "path=/tmp/app.cfg regexp='development' replace='production'"
ansible all -m command -a "cat /tmp/app.cfg"
```{{execute}}
