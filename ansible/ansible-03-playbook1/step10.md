# Шаг 10: Итоговое задание — полный provision nginx

Напишите production-ready плейбук с нуля, используя всё изученное:
переменные, условия, цикл, template, handlers, теги.

## 1. Создаём структуру проекта

```bash
mkdir -p ~/ansible-final-play/{templates,vars}
cd ~/ansible-final-play
```{{execute}}

## 2. Создаём шаблон конфига

```bash
cat > ~/ansible-final-play/templates/nginx.conf.j2 << 'TMPL'
# Ansible managed — {{ ansible_date_time.date }}
user www-data;
worker_processes {{ nginx_worker_processes }};
pid /run/nginx.pid;

events {
    worker_connections {{ nginx_worker_connections }};
}

http {
    sendfile on;
    tcp_nopush on;
    types_hash_max_size 2048;
    include /etc/nginx/mime.types;
    default_type application/octet-stream;

    access_log /var/log/nginx/access.log;
    error_log  /var/log/nginx/error.log;

    server {
        listen {{ http_port }};
        server_name {{ server_name }};
        root {{ web_root }};

        location / {
            index index.html;
            try_files $uri $uri/ =404;
        }

        location /healthz {
            return 200 "{{ app_name }}:OK
";
            add_header Content-Type text/plain;
        }
    }
}
TMPL
```{{execute}}

## 3. Создаём index.html шаблон

```bash
cat > ~/ansible-final-play/templates/index.html.j2 << 'TMPL'
<!DOCTYPE html>
<html>
<head><title>{{ app_name }}</title></head>
<body>
  <h1>{{ app_name }} v{{ app_version }}</h1>
  <p>Окружение: <strong>{{ env }}</strong></p>
  <p>Хост: {{ inventory_hostname }}</p>
  <p>Задеплоено: {{ ansible_date_time.date }}</p>
</body>
</html>
TMPL
```{{execute}}

## 4. Главный плейбук

```bash
cat > ~/ansible-final-play/site.yml << 'EOF'
---
- name: Provision веб-сервера nginx
  hosts: webservers
  become: yes
  gather_facts: yes

  vars:
    app_name: cr-it-app
    app_version: "1.0.0"
    env: production
    http_port: 80
    server_name: "{{ inventory_hostname }}"
    web_root: /var/www/cr-it
    nginx_worker_processes: auto
    nginx_worker_connections: 768
    required_packages:
      - nginx
      - curl

  handlers:
    - name: Перезапустить nginx
      service:
        name: nginx
        state: restarted

    - name: Перезагрузить nginx
      service:
        name: nginx
        state: reloaded

  tasks:
    # --- Установка ---
    - name: Обновить кеш apt
      apt:
        update_cache: yes
        cache_valid_time: 3600
      tags: [install]

    - name: Установить необходимые пакеты
      apt:
        name: "{{ item }}"
        state: present
      loop: "{{ required_packages }}"
      tags: [install, packages]

    # --- Конфигурация ---
    - name: Создать директорию сайта
      file:
        path: "{{ web_root }}"
        state: directory
        owner: www-data
        group: www-data
        mode: '0755'
      tags: [config]

    - name: Задеплоить конфиг nginx из шаблона
      template:
        src: templates/nginx.conf.j2
        dest: /etc/nginx/nginx.conf
        owner: root
        group: root
        mode: '0644'
        backup: yes
      notify: Перезапустить nginx
      tags: [config, nginx]

    # --- Деплой контента ---
    - name: Задеплоить index.html
      template:
        src: templates/index.html.j2
        dest: "{{ web_root }}/index.html"
        owner: www-data
        group: www-data
        mode: '0644'
      tags: [deploy, content]

    # --- Сервис ---
    - name: Убедиться, что nginx запущен и включён
      service:
        name: nginx
        state: started
        enabled: yes
      tags: [service]

    # --- Проверка ---
    - name: Проверить доступность
      uri:
        url: "http://localhost/healthz"
        return_content: yes
      register: health_check
      tags: [verify]

    - name: Показать результат проверки
      debug:
        msg: "Healthcheck: {{ health_check.content }}"
      tags: [verify]
EOF
```{{execute}}

## 5. Dry-run перед применением

```bash
cd ~/ansible-final-play
ansible-playbook site.yml -i ~/ansible-lab/hosts.yml --check --diff
```{{execute}}

## 6. Применяем плейбук

```bash
ansible-playbook site.yml -i ~/ansible-lab/hosts.yml
```{{execute}}

## 7. Проверяем

```bash
ansible webservers -i ~/ansible-lab/hosts.yml -m shell -a "curl -s http://localhost/healthz"
```{{execute}}

```bash
ansible webservers -i ~/ansible-lab/hosts.yml -m shell -a "curl -s http://localhost/"
```{{execute}}

## 8. Деплоим только контент (через тег)

```bash
ansible-playbook site.yml -i ~/ansible-lab/hosts.yml --tags deploy
```{{execute}}
