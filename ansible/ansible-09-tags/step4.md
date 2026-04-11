# Шаг 4: Запускаем несколько тегов сразу

Сделаем playbook с тремя тегами и выполним два из них.

```bash
cd /root/ansible-tags-demo

cat > playbook-multi-tags.yml <<'EOF'
- hosts: localhost
  gather_facts: false
  tasks:
    - copy:
        dest: /tmp/tag-config2.txt
        content: "config2\n"
      tags: [config]
    - copy:
        dest: /tmp/tag-smoke.txt
        content: "smoke\n"
      tags: [smoke]
    - copy:
        dest: /tmp/tag-deploy2.txt
        content: "deploy2\n"
      tags: [deploy]
EOF

rm -f /tmp/tag-config2.txt /tmp/tag-smoke.txt /tmp/tag-deploy2.txt
ansible-playbook -i inventory.ini playbook-multi-tags.yml --tags config,smoke
ls /tmp/tag-config2.txt /tmp/tag-smoke.txt > /root/ansible_multi_tags.txt
test -f /tmp/tag-deploy2.txt && echo present > /root/ansible_multi_tags_deploy.txt || echo absent > /root/ansible_multi_tags_deploy.txt
```{{execute}}
