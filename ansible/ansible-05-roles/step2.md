# Шаг 2: ansible-galaxy init — создание роли

`ansible-galaxy init` создаёт всю структуру директорий за одну команду.

## Создаём роль nginx

```bash
cd ~/ansible-roles-lab
ansible-galaxy init roles/nginx
```{{execute}}

```bash
# Смотрим что создалось
find roles/nginx -type f | sort
```{{execute}}

```bash
tree roles/nginx 2>/dev/null || find roles/nginx -print | sed 's|[^/]*/|  |g'
```{{execute}}

## Создаём ещё две роли

```bash
ansible-galaxy init roles/app
ansible-galaxy init roles/common
```{{execute}}

```bash
ls roles/
```{{execute}}

## Изучаем созданные файлы

```bash
cat roles/nginx/tasks/main.yml
```{{execute}}

```bash
cat roles/nginx/defaults/main.yml
```{{execute}}

```bash
cat roles/nginx/handlers/main.yml
```{{execute}}

```bash
cat roles/nginx/meta/main.yml
```{{execute}}

## README.md роли — документация

```bash
cat > roles/nginx/README.md << 'EOF'
# Роль: nginx

Устанавливает и настраивает nginx.

## Переменные (defaults)

| Переменная | По умолчанию | Описание |
|------------|-------------|----------|
| nginx_port | 80 | Порт для прослушивания |
| nginx_user | www-data | Пользователь nginx |
| nginx_worker_processes | auto | Количество воркеров |
| nginx_web_root | /var/www/html | Корень сайта |

## Пример использования

```yaml
- hosts: webservers
  roles:
    - role: nginx
      vars:
        nginx_port: 8080
```
EOF
cat roles/nginx/README.md
```{{execute}}
