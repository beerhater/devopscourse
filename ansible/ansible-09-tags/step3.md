# Шаг 3: Используем --skip-tags

Теперь запустим всё, кроме `deploy`.

```bash
cd /root/ansible-tags-demo
rm -f /tmp/tag-config.txt /tmp/tag-deploy.txt
ansible-playbook -i inventory.ini playbook.yml --skip-tags deploy
test -f /tmp/tag-config.txt && echo present > /root/ansible_skip_config.txt || echo absent > /root/ansible_skip_config.txt
test -f /tmp/tag-deploy.txt && echo present > /root/ansible_skip_deploy.txt || echo absent > /root/ansible_skip_deploy.txt
```{{execute}}
