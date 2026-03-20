# Шаг 10: Итоговое задание

Создайте production-ready плейбук, объединяющий всё изученное:
`vars_files`, `register`, `when`, `failed_when`, `changed_when`, `template` с Jinja2, `block/rescue`.

## 1. Подготовка

```bash
mkdir -p ~/ansible-capstone/{templates,vars}
cd ~/ansible-capstone
```{{execute}}

## 2. Файлы переменных

```bash
cat > ~/ansible-capstone/vars/app.yml << 'EOF'
app_name: capstone-app
app_version: "1.0.0"
app_port: 80
web_root: /var/www/capstone
nginx_worker_processes: auto
nginx_worker_connections: 768
nginx_gzip: true
nginx_gzip_types:
  - text/plain
  - text/css
  - application/json
EOF

cat > ~/ansible-capstone/vars/production.yml << 'EOF'
env: production
log_level: warn
debug_mode: false
EOF
```{{execute}}

## 3. Jinja2-шаблоны

```bash
cat > ~/ansible-capstone/templates/nginx.conf.j2 << 'TMPL'
user www-data;
worker_processes {{ nginx_worker_processes }};

events { worker_connections {{ nginx_worker_connections }}; }

http {
    include /etc/nginx/mime.types;
{% if nginx_gzip %}
    gzip on;
    gzip_types {{ nginx_gzip_types | join(' ') }};
{% endif %}

    server {
        listen {{ app_port }};
        server_name _;
        root {{ web_root }};

        location / { index index.html; try_files $uri $uri/ =404; }
        location /healthz { return 200 "{{ app_name }}:OK
"; add_header Content-Type text/plain; }
    }
}
TMPL

cat > ~/ansible-capstone/templates/index.html.j2 << 'TMPL'
<!DOCTYPE html>
<html>
<head><title>{{ app_name }}</title></head>
<body>
  <h1>{{ app_name }} v{{ app_version }}</h1>
  <p>Окружение: <strong>{{ env }}</strong></p>
  <p>Хост: {{ inventory_hostname }} | ОС: {{ ansible_distribution }}</p>
  <p>debug={{ debug_mode }} | log_level={{ log_level }}</p>
</body>
</html>
TMPL
```{{execute}}

## 4. Главный плейбук

```bash
cat > ~/ansible-capstone/site.yml << 'EOF'
---
- name: Capstone: полный provision nginx
  hosts: webservers
  become: yes
  gather_facts: yes

  vars_files:
    - vars/app.yml
    - vars/production.yml

  handlers:
    - name: Перезапустить nginx
      service:
        name: nginx
        state: restarted

  tasks:
    - name: Блок установки и конфигурации
      block:
        - name: Установить nginx
          apt:
            name: nginx
            state: present
            update_cache: yes

        - name: Создать директорию сайта
          file:
            path: "{{ web_root }}"
            state: directory
            owner: www-data
            group: www-data
            mode: '0755'

        - name: Задеплоить nginx.conf
          template:
            src: templates/nginx.conf.j2
            dest: /etc/nginx/nginx.conf
            backup: yes
          notify: Перезапустить nginx
          changed_when: true

        - name: Задеплоить index.html
          template:
            src: templates/index.html.j2
            dest: "{{ web_root }}/index.html"
            owner: www-data
            mode: '0644'

        - name: Запустить nginx
          service:
            name: nginx
            state: started
            enabled: yes

      rescue:
        - name: Восстановить оригинальный nginx.conf
          shell: "ls /etc/nginx/nginx.conf.* 2>/dev/null | tail -1 | xargs -I{} cp {} /etc/nginx/nginx.conf"
          ignore_errors: yes
        - name: Рестартовать nginx после отката
          service:
            name: nginx
            state: restarted
          ignore_errors: yes

    - name: Healthcheck
      uri:
        url: "http://localhost/healthz"
        return_content: yes
      register: health
      failed_when: "'OK' not in health.content"
      changed_when: false

    - name: Показать результат
      debug:
        msg: "Healthcheck: {{ health.content | trim }}"
EOF
```{{execute}}

## 5. Dry-run

```bash
cd ~/ansible-capstone
ansible-playbook site.yml -i ~/ansible-lab/hosts.yml --check --diff
```{{execute}}

## 6. Применяем

```bash
ansible-playbook site.yml -i ~/ansible-lab/hosts.yml
```{{execute}}

## 7. Меняем окружение через -e

```bash
ansible-playbook site.yml -i ~/ansible-lab/hosts.yml   -e "app_version=2.0.0"   --tags deploy
```{{execute}}

```bash
ansible all -i ~/ansible-lab/hosts.yml -m shell -a "curl -s http://localhost/healthz && curl -s http://localhost/"
```{{execute}}
