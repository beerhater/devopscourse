# Шаг 6: Собираем resilient playbook

Соберите playbook, где есть и ignore, и rescue-marker.

```bash
cd /root/ansible-error-demo

cat > playbook-resilient.yml <<'EOF'
- hosts: localhost
  gather_facts: false
  tasks:
    - block:
        - command: /bin/false
      rescue:
        - copy:
            dest: /tmp/resilient-rescue.txt
            content: "rescued\n"
      always:
        - copy:
            dest: /tmp/resilient-always.txt
            content: "always\n"

    - shell: echo post-check
      ignore_errors: true
      changed_when: false
EOF

rm -f /tmp/resilient-rescue.txt /tmp/resilient-always.txt
ansible-playbook -i inventory.ini playbook-resilient.yml
cat /tmp/resilient-rescue.txt /tmp/resilient-always.txt > /root/ansible_resilient_summary.txt
```{{execute}}
