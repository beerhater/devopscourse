# Шаг 5: -m file — файлы, директории, права, симлинки

Модуль `file` управляет атрибутами файлов без копирования содержимого.

## Создаём директории

```bash
cd ~/ansible-lab

# Создать директорию
ansible all -b -m file -a "path=/opt/myapp state=directory"
```{{execute}}

```bash
# Создать с конкретными правами
ansible all -b -m file -a "path=/opt/myapp/logs state=directory owner=root group=root mode=0755"
```{{execute}}

```bash
ansible all -m shell -a "ls -la /opt/"
```{{execute}}

## Состояния файла (state)

```bash
cat << 'EOF'
state=file        убедиться, что файл существует (не создаёт, только управляет атрибутами)
state=directory   убедиться, что директория существует (создаёт при отсутствии)
state=link        создать символическую ссылку
state=hard        создать жёсткую ссылку
state=touch       создать пустой файл если отсутствует (как команда touch)
state=absent      удалить файл/директорию/ссылку
EOF
```{{execute}}

## Создаём файлы и симлинки

```bash
# Создать пустой файл
ansible all -b -m file -a "path=/opt/myapp/app.log state=touch"
```{{execute}}

```bash
# Создать символическую ссылку
ansible all -b -m file -a "src=/opt/myapp path=/var/myapp state=link"
```{{execute}}

```bash
ansible all -m shell -a "ls -la /var/myapp && ls -la /opt/myapp/"
```{{execute}}

## Изменяем права рекурсивно

```bash
# recurse=yes: применить ко всем файлам/директориям внутри
ansible all -b -m file -a "path=/opt/myapp owner=root group=root mode=0755 recurse=yes"
```{{execute}}

```bash
ansible all -m shell -a "ls -la /opt/myapp/"
```{{execute}}

## Удаляем файлы и директории

```bash
# Удалить симлинк
ansible all -b -m file -a "path=/var/myapp state=absent"
```{{execute}}

```bash
# Удалить директорию со всем содержимым
ansible all -b -m file -a "path=/opt/myapp state=absent"
```{{execute}}
