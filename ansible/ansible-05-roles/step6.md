# Шаг 6: Использование ролей в плейбуке

## Синтаксис roles: (статический импорт)

```bash
cd ~/ansible-roles-lab

cat > site.yml << 'EOF'
---
- name: Provision веб-сервера
  hosts: webservers
  become: yes
  gather_facts: yes

  roles:
    - common          # роль без параметров
    - role: nginx     # роль с явным именем
    - role: nginx     # та же роль с переопределёнными переменными
      vars:
        nginx_port: 8080
        nginx_vhost_name: api
        nginx_web_root: /var/www/api
EOF
```{{execute}}

## import_role vs include_role

```bash
cat << 'EOF'
roles:           <- статический импорт до запуска play
import_role:     <- статический импорт, происходит в момент парсинга
include_role:    <- динамический импорт, происходит во время выполнения

Когда что использовать:
  roles: / import_role:  <- обычный случай
    + теги работают корректно
    + handler-ы из роли видны на уровне play
    - нельзя использовать в loop

  include_role:          <- когда нужна динамика
    + можно в loop
    + можно использовать с when динамически
    - теги работают иначе
EOF
```{{execute}}

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
    app_name: cr-it-app
    app_deploy_path: /var/www/cr-it

  pre_tasks:
    - name: Вывести информацию о запуске
      debug:
        msg: "Провижним {{ inventory_hostname }} ({{ ansible_distribution }})"

  roles:
    - role: common
    - role: nginx
    - role: app

  post_tasks:
    - name: Healthcheck после деплоя
      uri:
        url: "http://localhost/healthz"
        return_content: yes
      register: hc
      changed_when: false

    - name: Результат проверки
      debug:
        msg: "Healthcheck: {{ hc.content | trim }}"
EOF
```{{execute}}

## Роль common: базовые настройки любого сервера

```bash
cat > roles/common/tasks/main.yml << 'EOF'
---
- name: Обновить кеш apt
  apt:
    update_cache: yes
    cache_valid_time: 3600

- name: Установить базовые пакеты
  apt:
    name:
      - curl
      - wget
      - tree
      - htop
      - vim
    state: present

- name: Установить правильный часовой пояс
  timezone:
    name: "{{ common_timezone | default('UTC') }}"
  ignore_errors: yes

- name: Создать директорию для логов приложений
  file:
    path: /var/log/apps
    state: directory
    mode: '0755'
EOF
```{{execute}}

```bash
cat > roles/common/defaults/main.yml << 'EOF'
---
common_timezone: UTC
common_base_packages:
  - curl
  - wget
  - tree
EOF
```{{execute}}

```bash
# Запускаем плейбук с ролями
ansible-playbook site.yml -i hosts.yml --check --diff 2>&1 | head -40
```{{execute}}
