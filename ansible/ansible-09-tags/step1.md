# Шаг 1: Запускаем только tagged-задачи

Создайте playbook с двумя группами задач и выполните только `config`.

```bash
mkdir -p /root/ansible-tags-demo
cd /root/ansible-tags-demo

cat > inventory.ini <<'EOF'
localhost ansible_connection=local
EOF

cat > playbook.yml <<'EOF'
- hosts: localhost
  gather_facts: false
  tasks:
    - name: Config task
      copy:
        dest: /tmp/tag-config.txt
        content: "config updated\n"
      tags: [config]

    - name: Deploy task
      copy:
        dest: /tmp/tag-deploy.txt
        content: "deploy executed\n"
      tags: [deploy]
EOF

rm -f /tmp/tag-config.txt /tmp/tag-deploy.txt
ansible-playbook -i inventory.ini playbook.yml --tags config
cat /tmp/tag-config.txt > /root/ansible_tags_result.txt
test -f /tmp/tag-deploy.txt && echo present > /root/ansible_tags_deploy.txt || echo absent > /root/ansible_tags_deploy.txt

cat /root/ansible_tags_deploy.txt
```{{execute}}

Это удобно для точечных изменений без полного прогона всего стека.
