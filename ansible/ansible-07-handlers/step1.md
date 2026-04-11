# Шаг 1: notify и handler на localhost

Создайте playbook, где изменение файла триггерит handler.

```bash
mkdir -p /root/ansible-handlers-demo
cd /root/ansible-handlers-demo

cat > inventory.ini <<'EOF'
localhost ansible_connection=local
EOF

cat > playbook.yml <<'EOF'
- hosts: localhost
  gather_facts: false
  tasks:
    - name: Update config file
      copy:
        dest: /tmp/handler-demo.conf
        content: "version=2\n"
      notify: mark restart

  handlers:
    - name: mark restart
      copy:
        dest: /tmp/handler-ran.txt
        content: "handler executed\n"
EOF

rm -f /tmp/handler-demo.conf /tmp/handler-ran.txt
ansible-playbook -i inventory.ini playbook.yml
cat /tmp/handler-ran.txt > /root/ansible_handler_result.txt
cat /root/ansible_handler_result.txt
```{{execute}}

В production вместо marker-файла обычно был бы `service: state=restarted`.
