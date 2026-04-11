# Шаг 1: loop и when на практике

Создайте playbook, который создаёт несколько файлов в цикле и выполняет отдельную задачу только для `prod`.

```bash
mkdir -p /root/ansible-loops-demo
cd /root/ansible-loops-demo

cat > inventory.ini <<'EOF'
localhost ansible_connection=local
EOF

cat > playbook.yml <<'EOF'
- hosts: localhost
  gather_facts: false
  vars:
    env_name: prod
    app_files:
      - api
      - worker
      - cron
  tasks:
    - name: Create app marker files
      copy:
        dest: "/tmp/{{ item }}.txt"
        content: "{{ item }} ready\n"
      loop: "{{ app_files }}"

    - name: Create prod-only marker
      copy:
        dest: /tmp/prod-only.txt
        content: "prod deployment\n"
      when: env_name == "prod"
EOF

rm -f /tmp/api.txt /tmp/worker.txt /tmp/cron.txt /tmp/prod-only.txt
ansible-playbook -i inventory.ini playbook.yml
cat /tmp/prod-only.txt > /root/ansible_loop_result.txt
ls /tmp/api.txt /tmp/worker.txt /tmp/cron.txt > /root/ansible_loop_files.txt
```{{execute}}

Это очень частая связка для массовых однотипных действий с контролем по окружению.
