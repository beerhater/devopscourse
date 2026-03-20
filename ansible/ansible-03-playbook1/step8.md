# Шаг 8: Template — Jinja2-шаблоны для конфигов

Модуль `template` похож на `copy`, но перед копированием подставляет переменные.
Шаблоны используют синтаксис **Jinja2**: `{{ переменная }}`, `{% if %}`, `{% for %}`.

## Первый шаблон

```bash
mkdir -p ~/ansible-lab/templates
```{{execute}}

```bash
cat > ~/ansible-lab/templates/nginx.conf.j2 << 'EOF'
# Конфиг сгенерирован Ansible {{ ansible_date_time.date }}
# Хост: {{ inventory_hostname }}

server {
    listen {{ http_port | default(80) }};
    server_name {{ server_name | default('_') }};
    root {{ web_root | default('/var/www/html') }};

    access_log /var/log/nginx/{{ app_name }}_access.log;
    error_log  /var/log/nginx/{{ app_name }}_error.log;

    location / {
        index index.html;
        try_files $uri $uri/ =404;
    }

    location /healthz {
        return 200 "OK
";
        add_header Content-Type text/plain;
    }

{% if enable_status | default(false) %}
    location /status {
        stub_status on;
        allow 127.0.0.1;
        deny all;
    }
{% endif %}
}
EOF
cat ~/ansible-lab/templates/nginx.conf.j2
```{{execute}}

## Плейбук, использующий шаблон

```bash
cat > ~/ansible-lab/playbooks/template_demo.yml << 'EOF'
---
- name: Деплой nginx через шаблон
  hosts: webservers
  become: yes
  gather_facts: yes

  vars:
    app_name: myapp
    http_port: 80
    server_name: "{{ inventory_hostname }}"
    web_root: /var/www/myapp
    enable_status: true

  handlers:
    - name: Перезагрузить nginx
      service:
        name: nginx
        state: reloaded

  tasks:
    - name: Создать директорию сайта
      file:
        path: "{{ web_root }}"
        state: directory
        owner: www-data
        group: www-data
        mode: '0755'

    - name: Задеплоить конфиг nginx из шаблона
      template:
        src: ../templates/nginx.conf.j2
        dest: /etc/nginx/sites-available/{{ app_name }}.conf
        owner: root
        group: root
        mode: '0644'
      notify: Перезагрузить nginx

    - name: Включить сайт
      file:
        src: /etc/nginx/sites-available/{{ app_name }}.conf
        dest: /etc/nginx/sites-enabled/{{ app_name }}.conf
        state: link
      notify: Перезагрузить nginx

    - name: Задеплоить index.html
      copy:
        content: "<h1>{{ app_name }} — задеплоено через Ansible template!</h1>
"
        dest: "{{ web_root }}/index.html"
        owner: www-data
        mode: '0644'

    - name: Убедиться, что nginx запущен
      service:
        name: nginx
        state: started
        enabled: yes
EOF
ansible-playbook ~/ansible-lab/playbooks/template_demo.yml
```{{execute}}

```bash
# Проверяем — конфиг с подставленными переменными
ansible all -m shell -a "cat /etc/nginx/sites-available/myapp.conf"
```{{execute}}

```bash
ansible all -m shell -a "curl -s http://localhost/healthz"
```{{execute}}
