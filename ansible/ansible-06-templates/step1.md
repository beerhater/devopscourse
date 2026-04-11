# Шаг 1: Создаём template и рендерим конфиг

Создайте маленький Ansible-проект и срендерите конфиг на localhost.

```bash
mkdir -p /root/ansible-templates-demo/templates
cd /root/ansible-templates-demo

cat > inventory.ini <<'EOF'
localhost ansible_connection=local
EOF

cat > templates/app.conf.j2 <<'EOF'
APP_NAME={{ app_name }}
APP_ENV={{ app_env }}
APP_PORT={{ app_port }}
EOF

cat > playbook.yml <<'EOF'
- hosts: localhost
  gather_facts: false
  vars:
    app_name: payments-api
    app_env: prod
    app_port: 8080
  tasks:
    - name: Render config from template
      template:
        src: templates/app.conf.j2
        dest: /tmp/rendered-app.conf
EOF

ansible-playbook -i inventory.ini playbook.yml
cat /tmp/rendered-app.conf > /root/ansible_template_result.txt
cat /root/ansible_template_result.txt
```{{execute}}

Так обычно генерируют `.conf`, `.env` и другие конфиги из переменных.
