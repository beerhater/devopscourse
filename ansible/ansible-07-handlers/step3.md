# Шаг 3: Несколько задач notify один handler

Даже если несколько задач отправили `notify`, один handler должен выполниться один раз в конце.

```bash
cd /root/ansible-handlers-demo

cat > playbook-multi.yml <<'EOF'
- hosts: localhost
  gather_facts: false
  tasks:
    - copy:
        dest: /tmp/multi-1.txt
        content: "one\n"
      notify: mark multi restart
    - copy:
        dest: /tmp/multi-2.txt
        content: "two\n"
      notify: mark multi restart
  handlers:
    - name: mark multi restart
      copy:
        dest: /tmp/handler-multi.txt
        content: "multi handler executed\n"
EOF

rm -f /tmp/handler-multi.txt
ansible-playbook -i inventory.ini playbook-multi.yml
cat /tmp/handler-multi.txt > /root/ansible_handler_multi.txt
```{{execute}}
