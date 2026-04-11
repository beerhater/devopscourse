# Шаг 5: Запускаем только deploy-тег

Теперь выполним только deploy-задачу.

```bash
cd /root/ansible-tags-demo
rm -f /tmp/tag-config.txt /tmp/tag-deploy.txt
ansible-playbook -i inventory.ini playbook.yml --tags deploy
test -f /tmp/tag-config.txt && echo present > /root/ansible_deploy_config.txt || echo absent > /root/ansible_deploy_config.txt
test -f /tmp/tag-deploy.txt && echo present > /root/ansible_deploy_only.txt || echo absent > /root/ansible_deploy_only.txt
```{{execute}}
