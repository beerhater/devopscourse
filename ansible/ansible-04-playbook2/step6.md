# Шаг 6: Jinja2 в шаблонах — {% for %} и {% if %}

В файлах `.j2` доступен полный синтаксис Jinja2: циклы, условия, блоки.

## {% for %}: генерация повторяющихся блоков

```bash
mkdir -p ~/ansible-lab/templates
```{{execute}}

```bash
cat > ~/ansible-lab/templates/upstream.conf.j2 << 'EOF'
# Сгенерировано Ansible | {{ ansible_date_time.date }}
# Upstream для {{ app_name }}

upstream {{ app_name }}_backend {
    least_conn;
{% for server in backend_servers %}
    server {{ server.host }}:{{ server.port }}{% if not server.get('enabled', true) %} down{% endif %};
{% endfor %}
}

server {
    listen {{ http_port | default(80) }};
    server_name {{ server_names | join(' ') }};

    location / {
        proxy_pass http://{{ app_name }}_backend;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }

{% if enable_ssl | default(false) %}
    listen 443 ssl;
    ssl_certificate     /etc/ssl/{{ app_name }}.crt;
    ssl_certificate_key /etc/ssl/{{ app_name }}.key;
{% endif %}
}
EOF
cat ~/ansible-lab/templates/upstream.conf.j2
```{{execute}}

```bash
cat > ~/ansible-lab/playbooks/template_for.yml << 'EOF'
---
- name: Шаблон с for и if
  hosts: webservers
  become: yes
  gather_facts: yes

  vars:
    app_name: myapi
    http_port: 80
    enable_ssl: false
    server_names:
      - myapi.local
      - api.example.com
    backend_servers:
      - { host: "10.0.0.10", port: 3000, enabled: true }
      - { host: "10.0.0.11", port: 3000, enabled: true }
      - { host: "10.0.0.12", port: 3000, enabled: false }

  tasks:
    - name: Задеплоить конфиг nginx из шаблона
      template:
        src: ../templates/upstream.conf.j2
        dest: /etc/nginx/conf.d/{{ app_name }}.conf
        owner: root
        group: root
        mode: '0644'

    - name: Показать итоговый конфиг
      command: cat /etc/nginx/conf.d/{{ app_name }}.conf
      register: result

    - name: Вывод конфига
      debug:
        msg: "{{ result.stdout }}"
EOF
ansible-playbook ~/ansible-lab/playbooks/template_for.yml
```{{execute}}

## Шаблон hosts-файла через цикл

```bash
cat > ~/ansible-lab/templates/hosts.j2 << 'EOF'
127.0.0.1   localhost
::1         localhost

# Сгенерировано Ansible — {{ ansible_date_time.date }}
{% for host in groups['all'] %}
{{ hostvars[host]['ansible_default_ipv4']['address'] }}   {{ host }} {{ hostvars[host]['ansible_hostname'] }}
{% endfor %}
EOF
```{{execute}}

```bash
cat > ~/ansible-lab/playbooks/gen_hosts.yml << 'EOF'
---
- name: Сгенерировать /etc/hosts
  hosts: all
  become: yes
  gather_facts: yes

  tasks:
    - name: Задеплоить /etc/hosts
      template:
        src: ../templates/hosts.j2
        dest: /tmp/hosts_generated
        owner: root
        mode: '0644'

    - name: Показать результат
      command: cat /tmp/hosts_generated
      register: r
    - debug: msg="{{ r.stdout }}"
EOF
ansible-playbook ~/ansible-lab/playbooks/gen_hosts.yml
```{{execute}}
