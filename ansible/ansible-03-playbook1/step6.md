# Шаг 6: Handlers и notify — умный перезапуск

**Handler** — это задача, которая выполняется только тогда, когда её **уведомили (notify)**.
Главное правило: handler запускается **один раз в конце play**, даже если его уведомили несколько раз.

```
Задача изменила конфиг nginx  -> notify: Перезапустить nginx
Задача изменила SSL-сертификат -> notify: Перезапустить nginx
Задача изменила html-файл     -> (нет notify)

В конце play: handler запустится ОДИН раз (не три)
```

## Плейбук с handlers

```bash
cat > ~/ansible-lab/playbooks/handlers_demo.yml << 'EOF'
---
- name: Демонстрация handlers и notify
  hosts: webservers
  become: yes
  gather_facts: no

  handlers:
    - name: Перезапустить nginx
      service:
        name: nginx
        state: restarted

    - name: Перезагрузить nginx
      service:
        name: nginx
        state: reloaded

  tasks:
    - name: Убедиться, что nginx установлен
      apt:
        name: nginx
        state: present

    - name: Записать конфигурацию nginx
      copy:
        content: |
          server {
              listen 80;
              server_name _;
              root /var/www/html;
              location / { return 200 "handler demo
"; }
          }
        dest: /etc/nginx/sites-available/demo.conf
        owner: root
        group: root
        mode: '0644'
      notify: Перезагрузить nginx   # уведомит handler при changed=true

    - name: Включить сайт
      file:
        src: /etc/nginx/sites-available/demo.conf
        dest: /etc/nginx/sites-enabled/demo.conf
        state: link
      notify: Перезагрузить nginx   # можно уведомить несколько раз — выполнится один раз

    - name: Убедиться, что nginx запущен
      service:
        name: nginx
        state: started
        enabled: yes
EOF
ansible-playbook ~/ansible-lab/playbooks/handlers_demo.yml
```{{execute}}

```bash
# Запустим ещё раз — конфиг не изменился, handler НЕ запустится
ansible-playbook ~/ansible-lab/playbooks/handlers_demo.yml
```{{execute}}

## Принудительный запуск handlers (--force-handlers)

```bash
# Если плейбук упал в середине — handlers не запустятся
# --force-handlers запускает их даже при ошибке
ansible-playbook ~/ansible-lab/playbooks/handlers_demo.yml --force-handlers
```{{execute}}

## listen: handler слушает несколько тем

```bash
cat > ~/ansible-lab/playbooks/listen_demo.yml << 'EOF'
---
- name: Демонстрация listen
  hosts: webservers
  become: yes
  gather_facts: no

  handlers:
    - name: Перезапустить nginx
      service:
        name: nginx
        state: restarted
      listen: "обновить nginx"   # слушает эту тему

    - name: Очистить кеш
      command: echo "кеш очищен"
      listen: "обновить nginx"   # тоже слушает эту же тему

  tasks:
    - name: Обновить конфиг (notify по теме)
      copy:
        content: "server { listen 80; }
"
        dest: /tmp/nginx_test.conf
      notify: "обновить nginx"   # уведомляет ВСЕХ слушателей темы
EOF
ansible-playbook ~/ansible-lab/playbooks/listen_demo.yml
```{{execute}}
