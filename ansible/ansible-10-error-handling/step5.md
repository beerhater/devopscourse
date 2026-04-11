# Шаг 5: Управляем changed_when

Иногда задача что-то проверяет, но не должна считаться изменением.

```bash
cd /root/ansible-error-demo

cat > playbook-changed-when.yml <<'EOF'
- hosts: localhost
  gather_facts: false
  tasks:
    - shell: echo healthy
      register: health_result
      changed_when: false
EOF

ansible-playbook -i inventory.ini playbook-changed-when.yml > /root/ansible_changed_when.txt
cat /root/ansible_changed_when.txt
```{{execute}}
