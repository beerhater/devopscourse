# Шаг 10: Итоговое задание — полный стек из нескольких ролей

Создайте три роли (`common`, `nginx`, `app`) и запустите их через `site.yml`.

## 1. Финализируем роль common

```bash
cd ~/ansible-roles-lab
```{{execute}}

```bash
cat > roles/common/tasks/main.yml << 'EOF'
---
- name: Обновить кеш apt
  apt:
    update_cache: yes
    cache_valid_time: 3600

- name: Установить базовые пакеты
  apt:
    name: "{{ common_packages }}"
    state: present

- name: Создать директорию /var/log/apps
  file:
    path: /var/log/apps
    state: directory
    mode: '0755'
EOF

cat > roles/common/defaults/main.yml << 'EOF'
---
common_packages:
  - curl
  - wget
  - tree
EOF
```{{execute}}

## 2. Финализируем роль nginx

```bash
cat > roles/nginx/tasks/main.yml << 'EOF'
---
- name: Установить nginx
  apt:
    name: nginx
    state: present
    update_cache: yes

- name: Создать корневую директорию
  file:
    path: "{{ nginx_web_root }}"
    state: directory
    owner: "{{ nginx_user }}"
    mode: '0755'

- name: Задеплоить nginx.conf
  template:
    src: nginx.conf.j2
    dest: /etc/nginx/nginx.conf
    backup: yes
  notify: Перезапустить nginx

- name: Задеплоить vhost
  template:
    src: vhost.conf.j2
    dest: "{{ _nginx_conf_dir }}/{{ nginx_vhost_name }}.conf"
  notify: Перезагрузить nginx

- name: Убедиться, что nginx запущен
  service:
    name: nginx
    state: started
    enabled: yes
EOF
```{{execute}}

## 3. Финализируем роль app

```bash
cat > roles/app/tasks/main.yml << 'EOF'
---
- name: Создать пользователя деплоя
  user:
    name: "{{ app_user }}"
    state: present
    create_home: yes
    shell: /bin/bash

- name: Создать директорию приложения
  file:
    path: "{{ app_deploy_path }}"
    state: directory
    owner: "{{ app_user }}"
    group: www-data
    mode: '0755'

- name: Задеплоить index.html
  template:
    src: index.html.j2
    dest: "{{ app_deploy_path }}/index.html"
    owner: "{{ app_user }}"
    mode: '0644'
EOF
```{{execute}}

## 4. Финальный site.yml

```bash
cat > site.yml << 'EOF'
---
- name: Полный провижнинг веб-сервера
  hosts: webservers
  become: yes
  gather_facts: yes

  vars:
    nginx_web_root: /var/www/cr-it
    nginx_vhost_name: cr-it
    nginx_server_name: "{{ inventory_hostname }}"
    app_name: CR_IT Final
    app_version: "1.0.0"
    app_deploy_path: /var/www/cr-it
    app_user: deploy
    app_env: production

  roles:
    - role: common
    - role: nginx
    - role: app

  post_tasks:
    - name: Healthcheck
      uri:
        url: "http://localhost/healthz"
        return_content: yes
      register: hc
      changed_when: false

    - name: Провижнинг завершён
      debug:
        msg: "{{ inventory_hostname }} готов! Healthcheck: {{ hc.content | trim }}"
EOF
```{{execute}}

## 5. Dry-run

```bash
ansible-playbook site.yml -i hosts.yml --check --diff 2>&1 | grep -E 'TASK|PLAY|RECAP|changed|ok'
```{{execute}}

## 6. Применяем

```bash
ansible-playbook site.yml -i hosts.yml
```{{execute}}

## 7. Проверяем каждую роль отдельно

```bash
# Запустить только роль nginx (тег)
ansible-playbook site.yml -i hosts.yml --tags nginx
```{{execute}}

```bash
ansible all -i hosts.yml -m shell -a "curl -s http://localhost/healthz && echo '' && curl -s http://localhost/ | head -5"
```{{execute}}

## 8. Структура финального проекта

```bash
find ~/ansible-roles-lab -type f | grep -v '.git' | sort
```{{execute}}
