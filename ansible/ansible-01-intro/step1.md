# Шаг 1: Архитектура Ansible и установка

## Как работает Ansible

```
Вы запускаете:  ansible all -m ping
                    |
                    v
  Ansible читает инвентарь  ->  находит целевые хосты
  Ansible подключается SSH  ->  к каждому хосту
  Ansible копирует модуль   ->  /tmp/ansible_xxx.py
  Python запускает модуль   ->  на удалённом хосте
  Результат возвращается    ->  JSON на управляющий узел
  Временный файл удаляется  ->  никаких агентов не остаётся
```

Нет демона. Нет агента. Нет открытых портов на управляемых хостах (только SSH 22).

## Установка Ansible

```bash
apt-get update -qq && apt-get install -y python3-pip 2>/dev/null | tail -1
pip3 install ansible --quiet
```{{execute}}

```bash
ansible --version
```{{execute}}

```bash
# Управляющий узел: Python запускает Ansible
# Управляемый узел: Python запускает модуль (в большинстве дистрибутивов Python3 уже есть)
python3 --version
echo "Python на удалённом узле:"
ssh node01 python3 --version 2>/dev/null || echo "Проверим на следующем шаге"
```{{execute}}

## Основные компоненты

```bash
cat << 'EOF'
УПРАВЛЯЮЩИЙ УЗЕЛ (где запускаем Ansible):
  ansible          <- CLI для ad-hoc команд
  ansible-playbook <- запуск плейбуков
  ansible-galaxy   <- управление ролями и коллекциями
  ansible-vault    <- шифрование секретов
  ansible-doc      <- офлайн документация

УПРАВЛЯЕМЫЙ УЗЕЛ (требования):
  - Python 3.x установлен
  - SSH-сервер запущен (порт 22)
  - Пользователь с sudo ИЛИ root
  - Ansible НЕ нужен
EOF
```{{execute}}

```bash
# Сколько встроенных модулей доступно (офлайн)
ansible-doc -l | wc -l
echo "встроенных модулей"
```{{execute}}
