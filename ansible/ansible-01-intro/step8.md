# Шаг 8: YAML-формат инвентаря

INI прост, но YAML мощнее для сложных инвентарей.

## Конвертируем инвентарь в YAML

```bash
cat > ~/ansible-lab/hosts.yml << 'EOF'
all:
  vars:
    ansible_python_interpreter: /usr/bin/python3

  children:
    webservers:
      hosts:
        node01:
          http_port: 80
          server_name: web01.lab
      vars:
        nginx_version: "1.25"
        deploy_path: /var/www/html

    databases:
      hosts: {}   # пустая группа

    production:
      children:
        webservers:
        databases:
      vars:
        env: production
EOF
cat ~/ansible-lab/hosts.yml
```{{execute}}

```bash
cd ~/ansible-lab
# Используем YAML-инвентарь явно
ansible-inventory -i hosts.yml --graph
```{{execute}}

```bash
ansible-inventory -i hosts.yml --host node01
```{{execute}}

```bash
# Ping через YAML-инвентарь
ansible all -i hosts.yml -m ping
```{{execute}}

## Сравнение INI и YAML

```bash
cat << 'EOF'
Формат INI:
  + Простой, быстро написать
  + Хорош для маленьких инвентарей
  - Ограниченная вложенность
  - Переменные только как строки

Формат YAML:
  + Правильные типы данных (int, bool, список)
  + Глубокая вложенность (группа групп групп)
  + Удобен для git (чистые диффы)
  + Тот же синтаксис что и плейбуки
  - Более многословный

Рекомендация:
  Маленькая лаборатория -> INI подходит
  Продакшен             -> YAML + host_vars/ + group_vars/
EOF
```{{execute}}

```bash
# Обновляем ansible.cfg на YAML-инвентарь
sed -i 's/inventory = .\/hosts/inventory = .\/hosts.yml/' ~/ansible-lab/ansible.cfg
cat ~/ansible-lab/ansible.cfg | grep inventory
```{{execute}}

```bash
cd ~/ansible-lab
ansible all -m ping
```{{execute}}
