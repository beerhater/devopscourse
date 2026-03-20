# Шаг 4: Первый файл инвентаря — формат INI

Инвентарь сообщает Ansible, К КАКИМ хостам подключаться.
Расположение по умолчанию: `/etc/ansible/hosts` или произвольный файл с флагом `-i`.

## Создаём рабочую директорию проекта

```bash
mkdir -p ~/ansible-lab && cd ~/ansible-lab
```{{execute}}

## Базовый INI-инвентарь

```bash
cat > ~/ansible-lab/hosts << 'EOF'
# Это комментарий

# Хост без группы (попадает в неявную группу 'all')
node01

# Именованная группа: [имя_группы]
[webservers]
node01

[databases]
# node02  (в нашей лаборатории только один управляемый узел)
EOF
cat ~/ansible-lab/hosts
```{{execute}}

## INI-формат с переменными подключения

```bash
cat > ~/ansible-lab/hosts << 'EOF'
# Хост с переменными подключения (inline)
[webservers]
node01 ansible_user=root ansible_ssh_private_key_file=~/.ssh/ansible_id

[webservers:vars]
# Групповые переменные: применяются ко всем хостам группы webservers
http_port=80
app_name=myapp

[all:vars]
# Переменные для ВСЕХ хостов
ansible_python_interpreter=/usr/bin/python3
EOF
cat ~/ansible-lab/hosts
```{{execute}}

```bash
# Показать разобранный инвентарь
ansible-inventory -i ~/ansible-lab/hosts --list
```{{execute}}

```bash
# Дерево инвентаря
ansible-inventory -i ~/ansible-lab/hosts --graph
```{{execute}}

## Часто используемые переменные инвентаря

```bash
cat << 'EOF'
Переменные подключения:
  ansible_host                    <- IP или DNS (если имя хоста != адрес подключения)
  ansible_port                    <- порт SSH (по умолчанию: 22)
  ansible_user                    <- логин для SSH
  ansible_ssh_private_key_file    <- путь к приватному ключу
  ansible_python_interpreter      <- путь к Python на управляемом узле
  ansible_become                  <- повышение привилегий (sudo)
  ansible_become_user             <- пользователь после sudo (по умолчанию: root)
EOF
```{{execute}}
