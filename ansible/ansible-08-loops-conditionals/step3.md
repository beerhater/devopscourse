# Шаг 3: Условное пропускание задач

Проверим сценарий, когда задача должна быть пропущена.

```bash
cd /root/ansible-loops-demo

cat > playbook-skip.yml <<'EOF'
- hosts: localhost
  gather_facts: false
  vars:
    env_name: stage
  tasks:
    - copy:
        dest: /tmp/prod-should-not-exist.txt
        content: "prod only\n"
      when: env_name == "prod"
EOF

rm -f /tmp/prod-should-not-exist.txt
ansible-playbook -i inventory.ini playbook-skip.yml
test -f /tmp/prod-should-not-exist.txt && echo present > /root/ansible_when_skip.txt || echo absent > /root/ansible_when_skip.txt
```{{execute}}
