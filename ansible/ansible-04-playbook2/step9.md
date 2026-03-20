# Шаг 9: Продвинутые шаблоны Jinja2

## Сложный шаблон конфига nginx с несколькими секциями

```bash
cat > ~/ansible-lab/templates/nginx_full.conf.j2 << 'EOF'
# ============================================================
# Конфигурация nginx для {{ app_name }}
# Сгенерировано Ansible {{ ansible_date_time.date }} {{ ansible_date_time.time }}
# Хост: {{ inventory_hostname }}
# ============================================================

user {{ nginx_user | default('www-data') }};
worker_processes {{ nginx_worker_processes | default('auto') }};
pid /run/nginx.pid;

events {
    worker_connections {{ nginx_worker_connections | default(768) }};
    multi_accept on;
}

http {
    sendfile on;
    tcp_nopush on;
    keepalive_timeout {{ nginx_keepalive_timeout | default(65) }};
    client_max_body_size {{ nginx_client_max_body_size | default('10m') }};

    include /etc/nginx/mime.types;
    default_type application/octet-stream;

{% if nginx_gzip | default(true) %}
    gzip on;
    gzip_vary on;
    gzip_min_length 1024;
    gzip_types {{ nginx_gzip_types | default(['text/plain','text/css','application/json']) | join(' ') }};
{% endif %}

{% for vhost in virtual_hosts %}
    server {
        listen {{ vhost.port | default(80) }};
        server_name {{ vhost.server_name }};
        root {{ vhost.root | default('/var/www/html') }};

{% if vhost.redirect_to_https | default(false) %}
        return 301 https://$host$request_uri;
{% else %}
        location / {
            index index.html index.htm;
            try_files $uri $uri/ =404;
        }

{% if vhost.locations is defined %}
{% for loc in vhost.locations %}
        location {{ loc.path }} {
            {{ loc.directive }};
        }
{% endfor %}
{% endif %}
{% endif %}

        access_log /var/log/nginx/{{ vhost.server_name }}_access.log;
        error_log  /var/log/nginx/{{ vhost.server_name }}_error.log;
    }

{% endfor %}
}
EOF
```{{execute}}

```bash
cat > ~/ansible-lab/playbooks/nginx_full.yml << 'EOF'
---
- name: Полный конфиг nginx через шаблон
  hosts: webservers
  become: yes
  gather_facts: yes

  vars:
    app_name: cr-it
    nginx_worker_processes: auto
    nginx_worker_connections: 1024
    nginx_keepalive_timeout: 65
    nginx_client_max_body_size: 20m
    nginx_gzip: true
    nginx_gzip_types:
      - text/plain
      - text/css
      - application/json
      - application/javascript

    virtual_hosts:
      - server_name: "app.local"
        port: 80
        root: /var/www/cr-it
        locations:
          - { path: "/api", directive: "proxy_pass http://localhost:3000" }
          - { path: "/healthz", directive: "return 200 'OK'" }

      - server_name: "static.local"
        port: 8080
        root: /var/www/static
        locations:
          - { path: "/assets", directive: "expires 30d" }

  handlers:
    - name: Перезагрузить nginx
      service:
        name: nginx
        state: reloaded

  tasks:
    - name: Создать директории для сайтов
      file:
        path: "{{ item }}"
        state: directory
        owner: www-data
        mode: '0755'
      loop: "{{ virtual_hosts | map(attribute='root') | list }}"

    - name: Задеплоить nginx.conf из шаблона
      template:
        src: ../templates/nginx_full.conf.j2
        dest: /etc/nginx/nginx.conf
        backup: yes
      notify: Перезагрузить nginx

    - name: Показать итоговый конфиг
      command: cat /etc/nginx/nginx.conf
      register: conf
    - debug: msg="{{ conf.stdout }}"
EOF
ansible-playbook ~/ansible-lab/playbooks/nginx_full.yml
```{{execute}}
