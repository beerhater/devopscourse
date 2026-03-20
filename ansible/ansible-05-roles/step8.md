# Шаг 8: ansible-galaxy — установка ролей из Galaxy

Ansible Galaxy — публичный реестр готовых ролей.
Не нужно писать роль nginx с нуля — возьмите готовую.

## Поиск и установка ролей

```bash
# Поиск роли nginx
ansible-galaxy search nginx --author geerlingguy 2>/dev/null | head -10 || echo "Galaxy поиск требует интернета. Используем локальные роли."
```{{execute}}

```bash
# Установить популярную роль (требует интернет)
# ansible-galaxy install geerlingguy.nginx

# Показать установленные роли
ansible-galaxy list 2>/dev/null || echo "Нет установленных Galaxy-ролей"
```{{execute}}

## requirements.yml — фиксируем зависимости роли

```bash
cd ~/ansible-roles-lab

cat > requirements.yml << 'EOF'
---
roles:
  # Роль с Galaxy по имени
  - name: geerlingguy.nginx
    version: "3.2.0"

  # Роль из Git-репозитория
  - name: my_custom_role
    src: https://github.com/example/ansible-role-custom.git
    version: main

  # Роль из локального пути (для тестов)
  - name: nginx
    src: /tmp/nginx-role
EOF
cat requirements.yml
```{{execute}}

```bash
# Установить все зависимости из requirements.yml
# ansible-galaxy install -r requirements.yml
echo "requirements.yml готов — используется в CI/CD: ansible-galaxy install -r requirements.yml"
```{{execute}}

## Создание коллекции вместо одиночной роли

```bash
cat << 'EOF'
Современный Ansible использует КОЛЛЕКЦИИ (collections) вместо одиночных ролей.
Коллекция = набор ролей + модулей + плагинов + playbooks.

Структура коллекции:
  my_namespace/
    my_collection/
      roles/
        nginx/
        app/
      plugins/
        modules/
      playbooks/
      README.md
      galaxy.yml

Команды:
  ansible-galaxy collection init my_namespace.my_collection
  ansible-galaxy collection install my_namespace.my_collection
  ansible-galaxy collection list
EOF
```{{execute}}

```bash
# Список установленных коллекций
ansible-galaxy collection list 2>/dev/null | head -20
```{{execute}}
