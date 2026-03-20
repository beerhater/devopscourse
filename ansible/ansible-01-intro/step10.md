# Шаг 10: Итоговое задание — production-style проект

Создайте структуру Ansible-проекта с нуля.
Используйте всё изученное: ansible.cfg, YAML-инвентарь, host_vars, group_vars, ping.

## 1. Создаём структуру проекта

```bash
mkdir -p ~/ansible-final/{host_vars,group_vars}
cd ~/ansible-final
```{{execute}}

## 2. ansible.cfg

```bash
cat > ~/ansible-final/ansible.cfg << 'EOF'
[defaults]
inventory           = ./inventory.yml
remote_user         = root
private_key_file    = ~/.ssh/ansible_id
host_key_checking   = False
interpreter_python  = /usr/bin/python3
stdout_callback     = yaml
retry_files_enabled = False

[ssh_connection]
ssh_args    = -o ControlMaster=auto -o ControlPersist=60s -o StrictHostKeyChecking=no
pipelining  = True
EOF
```{{execute}}

## 3. YAML-инвентарь

```bash
cat > ~/ansible-final/inventory.yml << 'EOF'
all:
  children:
    webservers:
      hosts:
        node01:
    dbservers:
      hosts: {}
    production:
      children:
        webservers:
        dbservers:
EOF
```{{execute}}

## 4. group_vars

```bash
cat > ~/ansible-final/group_vars/all.yml << 'EOF'
ansible_python_interpreter: /usr/bin/python3
timezone: UTC
admin_email: ops@example.com
EOF

cat > ~/ansible-final/group_vars/webservers.yml << 'EOF'
nginx_port: 80
deploy_path: /var/www/html
nginx_worker_processes: auto
EOF

cat > ~/ansible-final/group_vars/production.yml << 'EOF'
env: production
log_level: warning
EOF
```{{execute}}

## 5. host_vars

```bash
cat > ~/ansible-final/host_vars/node01.yml << 'EOF'
server_role: primary-web
max_connections: 1024
disk_alert_threshold: 80
EOF
```{{execute}}

## 6. Проверяем структуру

```bash
find ~/ansible-final -type f | sort
```{{execute}}

```bash
cd ~/ansible-final
ansible-inventory --graph
```{{execute}}

```bash
# Все переменные node01 (объединённые из всех источников)
ansible-inventory --host node01
```{{execute}}

## 7. Запускаем ping — финальная проверка

```bash
cd ~/ansible-final
ansible all -m ping
```{{execute}}

```bash
ansible all -m setup -a "filter=ansible_distribution"
ansible all -m setup -a "filter=ansible_default_ipv4"
```{{execute}}

## 8. Итог проекта

```bash
echo "=== Структура проекта ===" && find ~/ansible-final -type f | sort
echo ""
echo "=== Граф инвентаря ===" && ansible-inventory --graph
echo ""
echo "=== Связность ===" && ansible all -m ping
```{{execute}}
