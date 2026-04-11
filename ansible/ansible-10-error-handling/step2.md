# Шаг 2: Пишем custom failed_when

Иногда команда формально успешна, но по смыслу результат всё равно плохой.

```bash
mkdir -p /root/ansible-error-demo
cd /root/ansible-error-demo

cat > playbook-failed-when.yml <<'EOF'
- hosts: localhost
  gather_facts: false
  tasks:
    - shell: echo ERROR
      register: cmd_result
      failed_when: "'ERROR' in cmd_result.stdout"
EOF

ansible-playbook -i inventory.ini playbook-failed-when.yml > /root/ansible_failed_when.txt 2>&1 || true
cat /root/ansible_failed_when.txt
```{{execute}}
