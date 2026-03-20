# Шаг 5: ansible.cfg — файл конфигурации

`ansible.cfg` задаёт параметры по умолчанию, чтобы не повторять флаги при каждой команде.
Ansible ищет его в таком порядке:
`ANSIBLE_CONFIG` (переменная окружения) > `./ansible.cfg` > `~/.ansible.cfg` > `/etc/ansible/ansible.cfg`

## Создаём ansible.cfg в директории проекта

```bash
cat > ~/ansible-lab/ansible.cfg << 'EOF'
[defaults]
# Файл инвентаря по умолчанию (флаг -i не нужен)
inventory = ./hosts

# Удалённый пользователь для SSH
remote_user = root

# Путь к приватному SSH-ключу
private_key_file = ~/.ssh/ansible_id

# Не проверять отпечатки хостов (удобно в лаборатории, НЕ для продакшена)
host_key_checking = False

# Интерпретатор Python на управляемых узлах
interpreter_python = /usr/bin/python3

# Формат вывода
stdout_callback = yaml

# Не создавать .retry файлы
retry_files_enabled = False

[ssh_connection]
# Переиспользовать SSH-соединения для ускорения (ControlMaster)
ssh_args = -o ControlMaster=auto -o ControlPersist=60s -o StrictHostKeyChecking=no
pipelining = True
EOF
cat ~/ansible-lab/ansible.cfg
```{{execute}}

```bash
cd ~/ansible-lab
# Проверяем, что Ansible подхватил конфиг
ansible --version | grep 'config file'
```{{execute}}

## Упрощаем инвентарь (переменные переехали в ansible.cfg)

```bash
cat > ~/ansible-lab/hosts << 'EOF'
[webservers]
node01

[all:vars]
ansible_python_interpreter=/usr/bin/python3
EOF
cat ~/ansible-lab/hosts
```{{execute}}

```bash
cd ~/ansible-lab && ansible-inventory --graph
```{{execute}}

## Важность host_key_checking

```bash
cat << 'EOF'
host_key_checking = False
  -- Только для лаборатории! Отключает проверку отпечатков SSH
  -- В продакшене: установить True и использовать known_hosts
  -- Без этого: первый запуск Ansible зависнет, ожидая ответа пользователя
EOF
```{{execute}}
