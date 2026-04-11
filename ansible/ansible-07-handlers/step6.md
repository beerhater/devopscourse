# Шаг 6: template + handler

Один из самых типичных сценариев: шаблон конфига изменился, значит сервис надо перезапустить.

```bash
cd /root/ansible-handlers-demo
mkdir -p templates

cat > templates/app.j2 <<'EOF'
PORT={{ app_port }}
EOF

cat > playbook-template-handler.yml <<'EOF'
- hosts: localhost
  gather_facts: false
  vars:
    app_port: 8080
  tasks:
    - template:
        src: templates/app.j2
        dest: /tmp/template-handler.conf
      notify: template changed
  handlers:
    - name: template changed
      copy:
        dest: /tmp/template-handler-marker.txt
        content: "template handler executed\n"
EOF

rm -f /tmp/template-handler-marker.txt
ansible-playbook -i inventory.ini playbook-template-handler.yml
cat /tmp/template-handler-marker.txt > /root/ansible_handler_template.txt
```{{execute}}
