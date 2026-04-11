# Шаг 2: Проверяем idempotency на втором запуске

Handler должен отрабатывать только при изменениях.

```bash
cd /root/ansible-handlers-demo
ansible-playbook -i inventory.ini playbook.yml > /root/ansible_handler_second_run.txt
cat /root/ansible_handler_second_run.txt
```{{execute}}
