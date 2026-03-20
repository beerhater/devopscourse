# Шаг 3: -m apt — управление пакетами

Модуль `apt` управляет пакетами на Debian/Ubuntu системах.
Он ИДЕМПОТЕНТЕН: запуск дважды даёт тот же результат.

## Установка пакетов

```bash
cd ~/ansible-lab

# Установить nginx
ansible all -b -m apt -a "name=nginx state=present update_cache=yes"
```{{execute}}

```bash
# Проверяем установку
ansible all -m shell -a "nginx -v"
```{{execute}}

```bash
# Установить несколько пакетов сразу
ansible all -b -m apt -a "name=curl,wget,tree state=present"
```{{execute}}

## Состояния пакета (state)

```bash
cat << 'EOF'
state=present    установить, если не установлен (ничего не делать, если уже есть)
state=latest     установить ИЛИ обновить до последней версии
state=absent     удалить пакет
state=build-dep  установить зависимости для сборки
EOF
```{{execute}}

```bash
# Идемпотентность: повторный запуск ничего не меняет (changed: false)
ansible all -b -m apt -a "name=nginx state=present"
```{{execute}}

## Обновление кеша пакетов

```bash
# update_cache=yes: аналог apt-get update
ansible all -b -m apt -a "update_cache=yes"
```{{execute}}

```bash
# cache_valid_time: пропустить обновление, если кеш свежий (в секундах)
ansible all -b -m apt -a "update_cache=yes cache_valid_time=3600"
```{{execute}}

## Удаление пакетов

```bash
ansible all -b -m apt -a "name=tree state=absent"
```{{execute}}

```bash
# purge=yes: удалить пакет + конфигурационные файлы
ansible all -b -m apt -a "name=tree state=absent purge=yes"
```{{execute}}

## Обновление всех пакетов

```bash
ansible all -b -m apt -a "upgrade=safe update_cache=yes" -o
```{{execute}}
