# Шаг 7: -m user и -m group — управление пользователями

## Создаём группы

```bash
cd ~/ansible-lab

# Создать группу
ansible all -b -m group -a "name=webteam state=present"
```{{execute}}

```bash
# Создать с конкретным GID
ansible all -b -m group -a "name=appgroup gid=1500 state=present"
```{{execute}}

```bash
ansible all -m shell -a "getent group webteam appgroup"
```{{execute}}

## Создаём пользователей

```bash
# Создать пользователя с домашней директорией
ansible all -b -m user -a "name=deploy comment='Пользователь деплоя' state=present create_home=yes"
```{{execute}}

```bash
# Создать с конкретным UID, группой, оболочкой
ansible all -b -m user -a "name=appuser uid=2000 group=webteam groups=sudo shell=/bin/bash state=present"
```{{execute}}

```bash
ansible all -m shell -a "id deploy && id appuser"
```{{execute}}

## Параметры пользователя

```bash
cat << 'EOF'
name         имя пользователя
uid          идентификатор пользователя
group        основная группа
groups       дополнительные группы (через запятую)
shell        оболочка входа
home         путь к домашней директории
create_home  создать домашнюю директорию (yes/no)
comment      поле GECOS (полное имя)
password     хэш пароля (используйте password_hash фильтр)
state        present / absent
system       yes = системная учётная запись (без домашней директории, без входа)
EOF
```{{execute}}

## Добавляем SSH-ключ пользователю

```bash
# Модуль authorized_key: добавить публичный SSH-ключ пользователю
ansible all -b -m authorized_key -a "user=deploy key='$(cat ~/.ssh/ansible_id.pub)' state=present"
```{{execute}}

```bash
ansible all -m shell -a "cat /home/deploy/.ssh/authorized_keys"
```{{execute}}

## Удаляем пользователей

```bash
# remove=yes: также удаляет домашнюю директорию и почтовый ящик
ansible all -b -m user -a "name=appuser state=absent remove=yes"
```{{execute}}
