# Шаг 5: templates/ и files/ внутри роли

Шаблоны и файлы внутри роли НЕ требуют указания полного пути —
Ansible ищет их автоматически в `roles/<name>/templates/` и `roles/<name>/files/`.

## Создаём шаблоны роли nginx

```bash
cd ~/ansible-roles-lab

cat > roles/nginx/templates/nginx.conf.j2 << 'EOF'
# Ansible managed | {{ ansible_date_time.date }}
user {{ nginx_user }};
worker_processes {{ nginx_worker_processes }};
pid {{ _nginx_pid_file }};

events {
    worker_connections {{ nginx_worker_connections }};
    multi_accept on;
}

http {
    sendfile on;
    tcp_nopush on;
    keepalive_timeout {{ nginx_keepalive_timeout }};
    client_max_body_size {{ nginx_client_max_body_size }};
    include /etc/nginx/mime.types;
    default_type application/octet-stream;

{% if nginx_gzip %}
    gzip on;
    gzip_vary on;
    gzip_types {{ nginx_gzip_types | join(' ') }};
{% endif %}

    access_log {{ nginx_access_log }};
    error_log {{ nginx_error_log }} {{ nginx_log_level }};

    include {{ _nginx_conf_dir }}/*.conf;
}
EOF
```{{execute}}

```bash
cat > roles/nginx/templates/vhost.conf.j2 << 'EOF'
server {
    listen {{ nginx_port }};
    server_name {{ nginx_server_name }};
    root {{ nginx_web_root }};

    location / {
        index index.html;
        try_files $uri $uri/ =404;
    }

    location /healthz {
        return 200 "{{ nginx_vhost_name }}:OK
";
        add_header Content-Type text/plain;
    }
}
EOF
```{{execute}}

## Создаём шаблон роли app

```bash
cat > roles/app/templates/index.html.j2 << 'EOF'
<!DOCTYPE html>
<html>
<head><title>{{ app_name }}</title></head>
<body>
  <h1>{{ app_name }} v{{ app_version }}</h1>
  <p>Окружение: <strong>{{ app_env }}</strong></p>
  <p>Хост: {{ inventory_hostname }}</p>
  <p>Путь деплоя: {{ app_deploy_path }}</p>
  <p>Пользователь: {{ app_user }}</p>
</body>
</html>
EOF
```{{execute}}

## files/ — статические файлы без шаблонизации

```bash
# В files/ кладём файлы которые копируются как есть (без Jinja2)
cat > roles/nginx/files/robots.txt << 'EOF'
User-agent: *
Disallow: /api/
Disallow: /admin/
Allow: /
EOF
```{{execute}}

```bash
# Добавляем задачу копирования статического файла
cat >> roles/nginx/tasks/main.yml << 'EOF'

- name: Скопировать robots.txt
  copy:
    src: robots.txt       # Ansible ищет в roles/nginx/files/robots.txt
    dest: "{{ nginx_web_root }}/robots.txt"
    owner: "{{ nginx_user }}"
    mode: '0644'
  tags: [nginx, files]
EOF
```{{execute}}

```bash
# Структура роли nginx теперь
find roles/nginx -type f | sort
```{{execute}}
