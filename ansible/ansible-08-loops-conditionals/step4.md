# Шаг 4: Рендерим сервисный список из loop

Теперь используем loop для сборки простого inventory-подобного файла.

```bash
cd /root/ansible-loops-demo

cat > playbook-services-list.yml <<'EOF'
- hosts: localhost
  gather_facts: false
  vars:
    services:
      - api
      - worker
      - cron
  tasks:
    - lineinfile:
        path: /tmp/services-list.txt
        line: "{{ item }}"
        create: true
      loop: "{{ services }}"
EOF

rm -f /tmp/services-list.txt
ansible-playbook -i inventory.ini playbook-services-list.yml
cat /tmp/services-list.txt > /root/ansible_services_list.txt
```{{execute}}
