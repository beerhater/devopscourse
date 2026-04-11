# Шаг 3: Используем ignore_errors

Иногда playbook должен зафиксировать ошибку, но не останавливаться полностью.

```bash
cd /root/ansible-error-demo

cat > playbook-ignore.yml <<'EOF'
- hosts: localhost
  gather_facts: false
  tasks:
    - command: /bin/false
      ignore_errors: true

    - copy:
        dest: /tmp/ignore-errors-marker.txt
        content: "continued after error\n"
EOF

rm -f /tmp/ignore-errors-marker.txt
ansible-playbook -i inventory.ini playbook-ignore.yml
cat /tmp/ignore-errors-marker.txt > /root/ansible_ignore_errors.txt
```{{execute}}
