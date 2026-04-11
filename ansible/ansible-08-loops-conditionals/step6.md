# Шаг 6: Собираем combined playbook

Соберите более жизненный playbook, где есть и `loop`, и `when`.

```bash
cd /root/ansible-loops-demo

cat > playbook-combined.yml <<'EOF'
- hosts: localhost
  gather_facts: false
  vars:
    env_name: prod
    services:
      - api
      - worker
  tasks:
    - copy:
        dest: "/tmp/{{ item }}-combined.txt"
        content: "{{ item }} combined\n"
      loop: "{{ services }}"

    - copy:
        dest: /tmp/combined-prod-only.txt
        content: "prod enabled\n"
      when: env_name == "prod"
EOF

rm -f /tmp/api-combined.txt /tmp/worker-combined.txt /tmp/combined-prod-only.txt
ansible-playbook -i inventory.ini playbook-combined.yml
ls /tmp/api-combined.txt /tmp/worker-combined.txt /tmp/combined-prod-only.txt > /root/ansible_combined_loop.txt
```{{execute}}
