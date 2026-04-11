# Шаг 5: Добавляем loop_control.label

`loop_control.label` делает вывод playbook намного удобнее для чтения.

```bash
cd /root/ansible-loops-demo

cat > playbook-loop-label.yml <<'EOF'
- hosts: localhost
  gather_facts: false
  vars:
    services:
      - { name: api, port: 8080 }
      - { name: worker, port: 9000 }
  tasks:
    - debug:
        msg: "{{ item.name }} -> {{ item.port }}"
      loop: "{{ services }}"
      loop_control:
        label: "{{ item.name }}"
EOF

ansible-playbook -i inventory.ini playbook-loop-label.yml > /root/ansible_loop_label.txt
cat /root/ansible_loop_label.txt
```{{execute}}
