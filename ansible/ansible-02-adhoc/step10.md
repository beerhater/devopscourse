# Шаг 10: Итоговое задание — провижнинг веб-сервера через ad-hoc

Используйте ТОЛЬКО ad-hoc команды, чтобы полностью настроить nginx на node01:
установка, конфигурация, создание пользователя, деплой контента, запуск и проверка.

## 1. Устанавливаем nginx

```bash
cd ~/ansible-lab
ansible all -b -m apt -a "name=nginx,curl state=present update_cache=yes"
```{{execute}}

## 2. Создаём пользователя deploy

```bash
ansible all -b -m user -a "name=deploy comment='Пользователь деплоя' state=present create_home=yes shell=/bin/bash"
```{{execute}}

```bash
ansible all -b -m authorized_key -a "user=deploy key='$(cat ~/.ssh/ansible_id.pub)' state=present"
```{{execute}}

## 3. Создаём веб-директорию с правами

```bash
ansible all -b -m file -a "path=/var/www/myapp state=directory owner=deploy group=www-data mode=0755"
```{{execute}}

## 4. Деплоим конфигурацию nginx

```bash
cat > /tmp/myapp.conf << 'EOF'
server {
    listen 80;
    server_name _;
    root /var/www/myapp;
    index index.html;
    location /healthz { return 200 "OK
"; add_header Content-Type text/plain; }
}
EOF
```{{execute}}

```bash
ansible all -b -m copy -a "src=/tmp/myapp.conf dest=/etc/nginx/sites-available/myapp.conf owner=root group=root mode=0644"
```{{execute}}

```bash
# Включаем сайт
ansible all -b -m file -a "src=/etc/nginx/sites-available/myapp.conf path=/etc/nginx/sites-enabled/myapp.conf state=link"
```{{execute}}

```bash
# Отключаем сайт по умолчанию
ansible all -b -m file -a "path=/etc/nginx/sites-enabled/default state=absent"
```{{execute}}

## 5. Деплоим index.html

```bash
ansible all -b -m copy -a "content='<h1>Задеплоено через Ansible ad-hoc!</h1>
' dest=/var/www/myapp/index.html owner=deploy group=www-data mode=0644"
```{{execute}}

## 6. Запускаем и включаем nginx

```bash
ansible all -b -m service -a "name=nginx state=restarted enabled=yes"
```{{execute}}

## 7. Проверяем

```bash
ansible all -m shell -a "curl -s http://localhost/"
ansible all -m shell -a "curl -s http://localhost/healthz"
ansible all -m shell -a "systemctl is-active nginx && systemctl is-enabled nginx"
```{{execute}}

## 8. Скачиваем лог доступа

```bash
ansible all -b -m shell -a "curl -s http://localhost/ > /dev/null && tail -3 /var/log/nginx/access.log"
```{{execute}}

## 9. Итоговый статус

```bash
ansible all -m shell -a "echo '=== nginx ===' && systemctl status nginx --no-pager | head -5"
ansible all -m shell -a "echo '=== пользователи ===' && id deploy"
ansible all -m shell -a "echo '=== файлы ===' && ls -la /var/www/myapp/"
```{{execute}}
