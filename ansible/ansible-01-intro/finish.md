# Модуль завершён!

## Что изучили

- **Архитектура Ansible** -- без агентов, через SSH, Python-модули на удалённом хосте
- **Требования к управляющему узлу** -- Ansible, SSH-ключ, файл инвентаря
- **Требования к управляемому узлу** -- только Python 3 + SSH-сервер
- **Генерация SSH-ключа** -- `ssh-keygen -t ed25519`, `ssh-copy-id`
- **ansible.cfg** -- inventory, remote_user, private_key_file, host_key_checking
- **INI-инвентарь** -- хосты, группы, [group:vars], [group:children]
- **YAML-инвентарь** -- иерархия all/children/hosts/vars
- **host_vars/ и group_vars/** -- чистая организация переменных
- **ansible all -m ping** -- тест связности (SSH + Python, не ICMP)
- **ansible -m setup** -- сбор фактов, фильтр `filter=`
- **raw vs command vs shell** -- когда использовать каждый тип

## Шпаргалка

```bash
# Генерация SSH-ключа
ssh-keygen -t ed25519 -f ~/.ssh/ansible_id -N ''
ssh-copy-id -i ~/.ssh/ansible_id.pub root@node01

# Проверка связности
ansible all -m ping
ansible all -m ping -v

# Сбор фактов
ansible all -m setup
ansible all -m setup -a 'filter=ansible_distribution*'

# Просмотр инвентаря
ansible-inventory --graph
ansible-inventory --host node01
ansible-inventory --list
```

## Следующий модуль

**Ad-hoc команды** -- `ansible all -m shell`, `-m apt`, `-m copy`, `-m service`.
