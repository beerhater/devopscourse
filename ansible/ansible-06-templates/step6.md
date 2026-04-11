# Шаг 6: Собираем production env-файл

Теперь сведём всё в более жизненный env-шаблон.

```bash
cd /root/ansible-templates-demo

cat > templates/prod.env.j2 <<'EOF'
APP_NAME={{ app_name }}
APP_ENV={{ app_env }}
APP_PORT={{ app_port }}
LOG_LEVEL={{ log_level | default('warn') }}
EOF

cat > playbook-prod-env.yml <<'EOF'
- hosts: localhost
  gather_facts: false
  vars:
    app_name: checkout-api
    app_env: production
    app_port: 8088
  tasks:
    - template:
        src: templates/prod.env.j2
        dest: /tmp/prod.env
EOF

ansible-playbook -i inventory.ini playbook-prod-env.yml
cat /tmp/prod.env > /root/ansible_template_prod_env.txt
```{{execute}}
