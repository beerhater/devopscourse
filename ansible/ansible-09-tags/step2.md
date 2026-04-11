# Шаг 2: Смотрим список тегов

Перед выборочным запуском полезно увидеть все теги playbook.

```bash
cd /root/ansible-tags-demo
ansible-playbook -i inventory.ini playbook.yml --list-tags > /root/ansible_list_tags.txt
cat /root/ansible_list_tags.txt
```{{execute}}
