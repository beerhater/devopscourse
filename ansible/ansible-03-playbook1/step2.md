# Шаг 2: Установка пакетов и идемпотентность

Ключевое свойство Ansible: **идемпотентность**.
Запуск плейбука дважды должен давать одинаковый результат.
Второй запуск не вносит изменений (changed=0), если состояние уже желаемое.

## Плейбук установки nginx

```bash
cat > ~/ansible-lab/playbooks/install_nginx.yml << 'EOF'
---
- name: Установка и запуск nginx
  hosts: webservers
  become: yes

  tasks:
    - name: Обновить кеш apt
      apt:
        update_cache: yes
        cache_valid_time: 3600   # обновлять не чаще раза в час

    - name: Установить nginx
      apt:
        name: nginx
        state: present

    - name: Убедиться, что nginx запущен и включён в автозапуск
      service:
        name: nginx
        state: started
        enabled: yes

    - name: Убедиться, что директория для сайта существует
      file:
        path: /var/www/html
        state: directory
        owner: www-data
        group: www-data
        mode: '0755'
EOF
```{{execute}}

```bash
cd ~/ansible-lab
# Первый запуск — установка
ansible-playbook playbooks/install_nginx.yml
```{{execute}}

```bash
# Второй запуск — всё уже на месте, changed=0
ansible-playbook playbooks/install_nginx.yml
```{{execute}}

```bash
# Проверяем: nginx запущен
ansible all -m shell -a "systemctl is-active nginx && curl -s http://localhost | head -3"
```{{execute}}

## gather_facts: отключение сбора фактов

```bash
cat << 'EOF'
По умолчанию Ansible запускает "Gathering Facts" перед первой задачей.
Это занимает ~2 секунды на хост.

Если факты не нужны — отключите:
  gather_facts: no

Это ускорит плейбуки с простыми задачами.
EOF
```{{execute}}

```bash
cat > ~/ansible-lab/playbooks/fast.yml << 'EOF'
---
- name: Быстрый плейбук без сбора фактов
  hosts: all
  become: no
  gather_facts: no

  tasks:
    - name: Проверить доступность
      command: hostname
EOF
ansible-playbook playbooks/fast.yml
```{{execute}}
