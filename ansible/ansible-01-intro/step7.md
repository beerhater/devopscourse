# Шаг 7: Группы инвентаря и переменные хостов

## Несколько групп и вложенность групп

```bash
cat > ~/ansible-lab/hosts << 'EOF'
# Один управляемый узел в нескольких группах
[webservers]
node01

[appservers]
node01

[databases]
# пусто в нашей лаборатории

# Родительская группа: содержит дочерние группы
[production:children]
webservers
appservers

# Переменные для группы production (наследуются дочерними)
[production:vars]
env=production
deploy_user=deploy

# Переменные для группы webservers
[webservers:vars]
http_port=80
https_port=443

# Для всех хостов
[all:vars]
ansible_python_interpreter=/usr/bin/python3
ansible_user=root
EOF
cat ~/ansible-lab/hosts
```{{execute}}

```bash
cd ~/ansible-lab
ansible-inventory --graph
```{{execute}}

```bash
# Все переменные node01 (из всех групп объединённые)
ansible-inventory --host node01
```{{execute}}

## Директории host_vars и group_vars (лучший подход)

```bash
# Переменные в файлах вместо inline — удобнее при большом количестве переменных
mkdir -p ~/ansible-lab/host_vars
mkdir -p ~/ansible-lab/group_vars

cat > ~/ansible-lab/host_vars/node01.yml << 'EOF'
http_port: 80
server_name: "web01.lab"
max_connections: 1024
EOF

cat > ~/ansible-lab/group_vars/webservers.yml << 'EOF'
nginx_version: "1.25"
deploy_path: /var/www/html
EOF

cat > ~/ansible-lab/group_vars/all.yml << 'EOF'
ansible_python_interpreter: /usr/bin/python3
timezone: UTC
ntp_server: pool.ntp.org
EOF
```{{execute}}

```bash
cd ~/ansible-lab
# Ansible-inventory автоматически подхватывает переменные из файлов
ansible-inventory --host node01
```{{execute}}

```bash
# Упрощаем hosts — переменные теперь в файлах
cat > ~/ansible-lab/hosts << 'EOF'
[webservers]
node01

[all:vars]
ansible_python_interpreter=/usr/bin/python3
EOF
```{{execute}}
