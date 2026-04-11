# Шаг 1: Обрабатываем сбой через rescue

Создайте playbook с намеренной ошибкой и обработайте её через `rescue`.

```bash
mkdir -p /root/ansible-error-demo
cd /root/ansible-error-demo

cat > inventory.ini <<'EOF'
localhost ansible_connection=local
EOF

cat > playbook.yml <<'EOF'
- hosts: localhost
  gather_facts: false
  tasks:
    - block:
        - name: Fail intentionally
          command: /bin/false
      rescue:
        - name: Write rescue marker
          copy:
            dest: /tmp/rescue-marker.txt
            content: "rescue executed\n"
      always:
        - name: Write always marker
          copy:
            dest: /tmp/always-marker.txt
            content: "always executed\n"
EOF

rm -f /tmp/rescue-marker.txt /tmp/always-marker.txt
ansible-playbook -i inventory.ini playbook.yml
cat /tmp/rescue-marker.txt > /root/ansible_rescue_result.txt
cat /tmp/always-marker.txt > /root/ansible_always_result.txt
```{{execute}}

Это полезно для rollback marker, cleanup и аккуратного завершения playbook после ошибки.
