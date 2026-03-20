# Шаг 9: Разбиение большого плейбука на роли

Берём монолитный плейбук и рефакторим в роли.

## Монолитный плейбук (до рефакторинга)

```bash
cd ~/ansible-roles-lab

cat > monolith.yml << 'EOF'
---
- name: Монолитный плейбук
  hosts: webservers
  become: yes
  gather_facts: yes

  vars:
    app_name: myapp
    nginx_port: 80
    deploy_user: deploy

  handlers:
    - name: Перезапустить nginx
      service: name=nginx state=restarted

  tasks:
    # --- Базовая настройка ---
    - apt: update_cache=yes
    - apt: name={{ item }} state=present
      loop: [curl, wget, vim]

    # --- Пользователь деплоя ---
    - user: name={{ deploy_user }} state=present create_home=yes shell=/bin/bash
    - authorized_key: user={{ deploy_user }} key="{{ lookup('file', '~/.ssh/ansible_id.pub') }}"

    # --- Nginx ---
    - apt: name=nginx state=present
    - template: src=... dest=/etc/nginx/nginx.conf
      notify: Перезапустить nginx
    - service: name=nginx state=started enabled=yes

    # --- Приложение ---
    - file: path=/var/www/{{ app_name }} state=directory owner={{ deploy_user }}
    - copy: content="hello" dest=/var/www/{{ app_name }}/index.html

    # ... ещё 200 строк ...
EOF
wc -l monolith.yml
```{{execute}}

## После рефакторинга: roles + site.yml

```bash
cat > site.yml << 'EOF'
---
- name: Provision веб-сервера
  hosts: webservers
  become: yes
  gather_facts: yes

  vars:
    nginx_web_root: /var/www/cr-it
    nginx_vhost_name: cr-it
    nginx_server_name: "{{ inventory_hostname }}"
    app_name: cr-it
    app_deploy_path: /var/www/cr-it
    app_user: deploy

  pre_tasks:
    - name: Начало провижнинга
      debug:
        msg: "Начинаем провижнинг {{ inventory_hostname }}"

  roles:
    - role: common
    - role: nginx
    - role: app

  post_tasks:
    - name: Проверка доступности
      uri:
        url: "http://localhost/healthz"
        return_content: yes
      register: check
      changed_when: false

    - name: Провижнинг завершён
      debug:
        msg: >
          Сервер {{ inventory_hostname }} готов.
          Healthcheck: {{ check.content | trim }}
EOF
wc -l site.yml
echo "Было 200+ строк, стало:"
wc -l site.yml
```{{execute}}

## Итоговая структура проекта

```bash
find ~/ansible-roles-lab -type f | grep -v '.git' | sort
```{{execute}}

## Принципы хорошего разбиения на роли

```bash
cat << 'EOF'
Принципы:
  1. Одна роль — одна ответственность
     nginx    <- только nginx
     app      <- только ваше приложение
     common   <- базовые настройки

  2. Роль должна работать независимо
     Можно применить только роль nginx без app

  3. defaults/ для всего настраиваемого
     Пользователь роли меняет defaults, не трогая tasks

  4. Версионируйте роли отдельно от плейбуков
     Роль v1.0 работает и в staging, и в production

  5. README.md — обязательно
     Документируйте все defaults-переменные с примерами
EOF
```{{execute}}
