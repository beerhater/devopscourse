# Шаг 7: meta/main.yml — зависимости ролей

`meta/main.yml` описывает зависимости: перед запуском роли Ansible автоматически
запустит все зависимые роли.

## Зависимость роли nginx от common

```bash
cd ~/ansible-roles-lab

cat > roles/nginx/meta/main.yml << 'EOF'
---
galaxy_info:
  role_name: nginx
  author: your_name
  description: Устанавливает и настраивает nginx
  min_ansible_version: "2.9"
  platforms:
    - name: Ubuntu
      versions: ["20.04", "22.04"]
    - name: Debian
      versions: ["10", "11", "12"]
  galaxy_tags:
    - nginx
    - web
    - linux

dependencies:
  - role: common    # common запустится АВТОМАТИЧЕСКИ перед nginx
    vars:
      common_timezone: UTC
EOF
cat roles/nginx/meta/main.yml
```{{execute}}

```bash
# Теперь site.yml можно упростить — common применится автоматически через meta
cat > site_with_deps.yml << 'EOF'
---
- name: Provision через зависимости ролей
  hosts: webservers
  become: yes
  gather_facts: yes

  vars:
    nginx_web_root: /var/www/cr-it
    nginx_vhost_name: cr-it
    app_name: cr-it
    app_deploy_path: /var/www/cr-it

  roles:
    - role: nginx    # common запустится автоматически!
    - role: app
EOF
```{{execute}}

## allow_duplicates: запуск роли несколько раз

```bash
cat << 'EOF'
По умолчанию Ansible запускает одну и ту же роль ОДИН раз (дедупликация).
Если нужно запустить роль дважды с разными переменными — используйте:

  # В meta/main.yml роли:
  allow_duplicates: true

Пример: роль nginx запускается дважды — для порта 80 и порта 8080
EOF
```{{execute}}

```bash
cat >> roles/nginx/meta/main.yml << 'EOF'

allow_duplicates: true
EOF
```{{execute}}

```bash
cat > site_dual.yml << 'EOF'
---
- name: Два vhost через одну роль
  hosts: webservers
  become: yes
  gather_facts: yes

  roles:
    - role: nginx
      vars:
        nginx_port: 80
        nginx_vhost_name: main
        nginx_web_root: /var/www/main

    - role: nginx
      vars:
        nginx_port: 8080
        nginx_vhost_name: api
        nginx_web_root: /var/www/api
EOF
```{{execute}}

```bash
# Посмотрим список задач (без выполнения)
ansible-playbook site_with_deps.yml -i hosts.yml --list-tasks 2>&1 | head -30
```{{execute}}
