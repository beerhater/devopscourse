# Шаг 3: tasks/main.yml и handlers/main.yml

## Заполняем tasks/main.yml роли nginx

```bash
cd ~/ansible-roles-lab

cat > roles/nginx/tasks/main.yml << 'EOF'
---
# tasks/main.yml — задачи роли nginx

- name: Обновить кеш apt
  apt:
    update_cache: yes
    cache_valid_time: 3600
  tags: [nginx, install]

- name: Установить nginx
  apt:
    name: nginx
    state: present
  tags: [nginx, install]

- name: Создать корневую директорию сайта
  file:
    path: "{{ nginx_web_root }}"
    state: directory
    owner: "{{ nginx_user }}"
    group: "{{ nginx_user }}"
    mode: '0755'
  tags: [nginx, config]

- name: Задеплоить конфиг nginx из шаблона
  template:
    src: nginx.conf.j2
    dest: /etc/nginx/nginx.conf
    owner: root
    group: root
    mode: '0644'
    backup: yes
  notify: Перезапустить nginx
  tags: [nginx, config]

- name: Задеплоить конфиг виртуального хоста
  template:
    src: vhost.conf.j2
    dest: "{{ _nginx_conf_dir }}/{{ nginx_vhost_name }}.conf"
    owner: root
    group: root
    mode: '0644'
  notify: Перезагрузить nginx
  tags: [nginx, config, vhost]

- name: Убедиться, что nginx запущен и включён
  service:
    name: nginx
    state: started
    enabled: yes
  tags: [nginx, service]
EOF
cat roles/nginx/tasks/main.yml
```{{execute}}

## Заполняем handlers/main.yml

```bash
cat > roles/nginx/handlers/main.yml << 'EOF'
---
# handlers/main.yml — обработчики роли nginx

- name: Перезапустить nginx
  service:
    name: nginx
    state: restarted

- name: Перезагрузить nginx
  service:
    name: nginx
    state: reloaded

- name: Проверить конфиг nginx
  command: nginx -t
  listen: "проверить конфиг nginx"
EOF
cat roles/nginx/handlers/main.yml
```{{execute}}

## Разбиение tasks на несколько файлов

```bash
# Большие роли разбивают tasks на файлы и подключают через include_tasks
mkdir -p roles/nginx/tasks

cat > roles/nginx/tasks/install.yml << 'EOF'
---
- name: Обновить кеш apt
  apt:
    update_cache: yes
    cache_valid_time: 3600

- name: Установить nginx
  apt:
    name: nginx
    state: present
EOF

cat > roles/nginx/tasks/configure.yml << 'EOF'
---
- name: Задеплоить nginx.conf
  template:
    src: nginx.conf.j2
    dest: /etc/nginx/nginx.conf
  notify: Перезапустить nginx

- name: Задеплоить vhost
  template:
    src: vhost.conf.j2
    dest: "{{ _nginx_conf_dir }}/{{ nginx_vhost_name }}.conf"
  notify: Перезагрузить nginx
EOF
```{{execute}}

```bash
# Обновлённый main.yml использует include_tasks
cat > roles/nginx/tasks/main.yml << 'EOF'
---
- import_tasks: install.yml
  tags: [nginx, install]

- name: Создать корневую директорию
  file:
    path: "{{ nginx_web_root }}"
    state: directory
    owner: "{{ nginx_user }}"
    mode: '0755'
  tags: [nginx, config]

- import_tasks: configure.yml
  tags: [nginx, config]

- name: Убедиться, что nginx запущен
  service:
    name: nginx
    state: started
    enabled: yes
  tags: [nginx, service]
EOF
```{{execute}}
