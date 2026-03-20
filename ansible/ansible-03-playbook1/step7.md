# Шаг 7: Теги — запуск избранных задач

Теги позволяют запустить **только часть плейбука**, не выполняя всё подряд.

## Добавляем теги к задачам

```bash
cat > ~/ansible-lab/playbooks/tagged.yml << 'EOF'
---
- name: Плейбук с тегами
  hosts: webservers
  become: yes
  gather_facts: yes

  tasks:
    - name: Установить nginx
      apt:
        name: nginx
        state: present
        update_cache: yes
      tags:
        - install
        - packages

    - name: Установить curl
      apt:
        name: curl
        state: present
      tags:
        - install
        - packages

    - name: Записать конфигурацию nginx
      copy:
        content: |
          server {
              listen 80;
              server_name _;
              location / { return 200 "OK
"; }
          }
        dest: /etc/nginx/conf.d/app.conf
      tags:
        - config
        - nginx

    - name: Деплоить index.html
      copy:
        content: "<h1>Задеплоено Ansible</h1>
"
        dest: /var/www/html/index.html
      tags:
        - deploy
        - content

    - name: Запустить nginx
      service:
        name: nginx
        state: started
        enabled: yes
      tags:
        - service
        - nginx

    - name: Задача всегда (без тегов)
      debug:
        msg: "Эта задача всегда выполняется"
EOF
```{{execute}}

```bash
# Запустить ТОЛЬКО задачи с тегом install
ansible-playbook ~/ansible-lab/playbooks/tagged.yml --tags install
```{{execute}}

```bash
# Запустить ТОЛЬКО config и service
ansible-playbook ~/ansible-lab/playbooks/tagged.yml --tags "config,service"
```{{execute}}

```bash
# Пропустить задачи с тегом deploy
ansible-playbook ~/ansible-lab/playbooks/tagged.yml --skip-tags deploy
```{{execute}}

```bash
# Список всех тегов в плейбуке
ansible-playbook ~/ansible-lab/playbooks/tagged.yml --list-tags
```{{execute}}

```bash
# Список всех задач с тегами
ansible-playbook ~/ansible-lab/playbooks/tagged.yml --list-tasks
```{{execute}}
