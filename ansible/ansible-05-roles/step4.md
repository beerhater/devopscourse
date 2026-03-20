# Шаг 4: defaults/main.yml и vars/main.yml

## Заполняем defaults/main.yml (переопределяемые значения)

```bash
cd ~/ansible-roles-lab

cat > roles/nginx/defaults/main.yml << 'EOF'
---
# defaults/main.yml — переменные по умолчанию (НИЗКИЙ приоритет)
# Пользователь МОЖЕТ переопределить любую из них

nginx_port: 80
nginx_user: www-data
nginx_worker_processes: auto
nginx_worker_connections: 768
nginx_keepalive_timeout: 65
nginx_client_max_body_size: "10m"
nginx_gzip: true
nginx_gzip_types:
  - text/plain
  - text/css
  - application/json
  - application/javascript

nginx_web_root: /var/www/html
nginx_vhost_name: default
nginx_server_name: "_"

nginx_access_log: /var/log/nginx/access.log
nginx_error_log: /var/log/nginx/error.log
nginx_log_level: warn
EOF
cat roles/nginx/defaults/main.yml
```{{execute}}

## Заполняем vars/main.yml (внутренние константы)

```bash
cat > roles/nginx/vars/main.yml << 'EOF'
---
# vars/main.yml — внутренние константы (ВЫСОКИЙ приоритет)
# Не предназначены для переопределения снаружи

_nginx_conf_dir: /etc/nginx/conf.d
_nginx_sites_available: /etc/nginx/sites-available
_nginx_sites_enabled: /etc/nginx/sites-enabled
_nginx_pid_file: /run/nginx.pid
EOF
cat roles/nginx/vars/main.yml
```{{execute}}

## Демонстрация приоритета

```bash
cat << 'EOF'
Приоритет переменных роли (от низшего к высшему):

  role defaults/main.yml    <- самый низкий (легко переопределить)
  inventory group_vars
  inventory host_vars
  play vars
  play vars_files
  role vars/main.yml        <- высокий (трудно переопределить)
  block vars
  task vars
  extra vars (-e)           <- самый высокий

Практика:
  defaults/ <- всё что пользователь роли ДОЛЖЕН настраивать
  vars/     <- всё что является ДЕТАЛЬЮ РЕАЛИЗАЦИИ роли
EOF
```{{execute}}

## Роль app с переменными

```bash
cat > roles/app/defaults/main.yml << 'EOF'
---
app_name: myapp
app_version: "1.0.0"
app_user: deploy
app_group: www-data
app_deploy_path: /var/www/myapp
app_port: 3000
app_env: production
EOF

cat > roles/app/tasks/main.yml << 'EOF'
---
- name: Создать пользователя деплоя
  user:
    name: "{{ app_user }}"
    group: "{{ app_group }}"
    state: present
    create_home: yes
    shell: /bin/bash

- name: Создать директорию приложения
  file:
    path: "{{ app_deploy_path }}"
    state: directory
    owner: "{{ app_user }}"
    group: "{{ app_group }}"
    mode: '0755'

- name: Задеплоить index.html
  template:
    src: index.html.j2
    dest: "{{ app_deploy_path }}/index.html"
    owner: "{{ app_user }}"
    group: "{{ app_group }}"
    mode: '0644'
EOF
```{{execute}}
