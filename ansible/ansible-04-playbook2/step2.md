# Шаг 2: vars_files — переменные из файлов

`vars_files` загружает переменные из внешних YAML-файлов.
Удобно: разные файлы для разных окружений, секреты в отдельном файле.

## Создаём файлы переменных

```bash
mkdir -p ~/ansible-lab/vars
```{{execute}}

```bash
cat > ~/ansible-lab/vars/app.yml << 'EOF'
app_name: cr-it-web
app_version: "2.0.0"
app_port: 8080
app_user: www-data
deploy_path: /var/www/cr-it
EOF
```{{execute}}

```bash
cat > ~/ansible-lab/vars/nginx.yml << 'EOF'
nginx_worker_processes: auto
nginx_worker_connections: 1024
nginx_keepalive_timeout: 65
nginx_client_max_body_size: 10m
nginx_gzip: true
nginx_gzip_types:
  - text/plain
  - text/css
  - application/json
  - application/javascript
EOF
```{{execute}}

```bash
cat > ~/ansible-lab/vars/production.yml << 'EOF'
env: production
log_level: warn
debug_mode: false
allowed_ips:
  - 10.0.0.0/8
  - 192.168.0.0/16
EOF
```{{execute}}

## Плейбук с vars_files

```bash
cat > ~/ansible-lab/playbooks/vars_files_demo.yml << 'EOF'
---
- name: Переменные из файлов
  hosts: all
  become: no
  gather_facts: no

  vars_files:
    - ../vars/app.yml
    - ../vars/nginx.yml
    - ../vars/production.yml

  tasks:
    - name: Параметры приложения
      debug:
        msg: "{{ app_name }} v{{ app_version }} на порту {{ app_port }}"

    - name: Параметры nginx
      debug:
        msg: "nginx: workers={{ nginx_worker_processes }}, gzip={{ nginx_gzip }}"

    - name: Параметры окружения
      debug:
        msg: "env={{ env }}, debug={{ debug_mode }}, allowed_ips={{ allowed_ips }}"
EOF
ansible-playbook ~/ansible-lab/playbooks/vars_files_demo.yml
```{{execute}}

## Динамическая загрузка по окружению

```bash
cat > ~/ansible-lab/vars/staging.yml << 'EOF'
env: staging
log_level: info
debug_mode: true
allowed_ips:
  - 0.0.0.0/0
EOF
```{{execute}}

```bash
cat > ~/ansible-lab/playbooks/env_vars.yml << 'EOF'
---
- name: Загрузка переменных по окружению
  hosts: all
  become: no
  gather_facts: no

  vars:
    target_env: production   # переопределяйте через -e

  vars_files:
    - ../vars/app.yml
    - ../vars/{{ target_env }}.yml   # динамическое имя файла!

  tasks:
    - name: Показать конфигурацию
      debug:
        msg: "{{ app_name }} в окружении {{ env }} (debug={{ debug_mode }})"
EOF
```{{execute}}

```bash
ansible-playbook ~/ansible-lab/playbooks/env_vars.yml
```{{execute}}

```bash
# Загрузить переменные staging окружения
ansible-playbook ~/ansible-lab/playbooks/env_vars.yml -e "target_env=staging"
```{{execute}}
