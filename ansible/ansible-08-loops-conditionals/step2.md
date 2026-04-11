# Шаг 2: Loop по списку словарей

`loop` особенно удобен, когда элементы содержат несколько полей.

```bash
cd /root/ansible-loops-demo

cat > playbook-dicts.yml <<'EOF'
- hosts: localhost
  gather_facts: false
  vars:
    services:
      - { name: api, port: 8080 }
      - { name: worker, port: 9000 }
  tasks:
    - copy:
        dest: "/tmp/{{ item.name }}-{{ item.port }}.txt"
        content: "{{ item.name }} {{ item.port }}\n"
      loop: "{{ services }}"
EOF

ansible-playbook -i inventory.ini playbook-dicts.yml
ls /tmp/api-8080.txt /tmp/worker-9000.txt > /root/ansible_loop_dicts.txt
```{{execute}}
