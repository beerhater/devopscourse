# Шаг 5: Рендер nested variables

В реальной автоматизации переменные часто приходят вложенной структурой.

```bash
cd /root/ansible-templates-demo

cat > templates/nested.conf.j2 <<'EOF'
APP_NAME={{ app.name }}
APP_PORT={{ app.port }}
APP_ENV={{ app.env }}
EOF

cat > playbook-nested.yml <<'EOF'
- hosts: localhost
  gather_facts: false
  vars:
    app:
      name: billing-api
      port: 9090
      env: stage
  tasks:
    - template:
        src: templates/nested.conf.j2
        dest: /tmp/nested.conf
EOF

ansible-playbook -i inventory.ini playbook-nested.yml
cat /tmp/nested.conf > /root/ansible_template_nested.txt
```{{execute}}
