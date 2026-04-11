# Шаг 4: Используем listen

`listen` помогает нескольким handler реагировать на одно логическое событие.

```bash
cd /root/ansible-handlers-demo

cat > playbook-listen.yml <<'EOF'
- hosts: localhost
  gather_facts: false
  tasks:
    - copy:
        dest: /tmp/listen-demo.txt
        content: "listen demo\n"
      notify: restart app
  handlers:
    - name: write listen marker
      listen: restart app
      copy:
        dest: /tmp/handler-listen.txt
        content: "listen handler executed\n"
EOF

rm -f /tmp/handler-listen.txt
ansible-playbook -i inventory.ini playbook-listen.yml
cat /tmp/handler-listen.txt > /root/ansible_handler_listen.txt
```{{execute}}
