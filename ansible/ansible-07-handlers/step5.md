# Шаг 5: Принудительный flush_handlers

Иногда нужно выполнить handler раньше конца play.

```bash
cd /root/ansible-handlers-demo

cat > playbook-flush.yml <<'EOF'
- hosts: localhost
  gather_facts: false
  tasks:
    - copy:
        dest: /tmp/flush-demo.txt
        content: "flush me\n"
      notify: flush marker

    - meta: flush_handlers

    - shell: test -f /tmp/handler-flush.txt && echo present || echo absent
      register: flush_check

    - copy:
        dest: /tmp/flush-check.txt
        content: "{{ flush_check.stdout }}\n"

  handlers:
    - name: flush marker
      copy:
        dest: /tmp/handler-flush.txt
        content: "flushed\n"
EOF

rm -f /tmp/handler-flush.txt /tmp/flush-check.txt
ansible-playbook -i inventory.ini playbook-flush.yml
cat /tmp/flush-check.txt > /root/ansible_handler_flush.txt
```{{execute}}
