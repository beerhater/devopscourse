# Модуль завершён! Раздел Ansible пройден!

## Что изучили в этом модуле

- **Структура роли** -- `tasks/`, `handlers/`, `templates/`, `files/`, `defaults/`, `vars/`, `meta/`
- **ansible-galaxy init** -- создание скелета роли за одну команду
- **tasks/main.yml** -- задачи роли; разбиение на файлы через `import_tasks`
- **defaults/main.yml** -- переопределяемые переменные с низким приоритетом
- **vars/main.yml** -- внутренние константы роли с высоким приоритетом
- **templates/** и **files/** -- Ansible ищет автоматически в роли
- **roles:** в плейбуке -- статический импорт
- **include_role:** -- динамический импорт (для loop и when)
- **meta/main.yml** -- зависимости ролей, `allow_duplicates`
- **requirements.yml** -- фиксирование зависимостей для CI/CD
- **Рефакторинг** -- монолит → набор ролей

## Весь раздел Ansible

| Модуль | Тема |
|--------|------|
| 01 | Введение: inventory, SSH-ключи, первый ping |
| 02 | Ad-hoc команды: shell, apt, copy, service, user |
| 03 | Playbook ч.1: структура, tasks, handlers, template |
| 04 | Playbook ч.2: variables, Jinja2, when, block/rescue |
| 05 | Roles: структура роли, разбиение плейбука |

## Шпаргалка по ролям

```bash
# Создать роль
ansible-galaxy init roles/my_role

# Структура
roles/my_role/
  tasks/main.yml      <- задачи
  handlers/main.yml   <- handlers
  templates/*.j2      <- шаблоны
  files/*             <- статические файлы
  defaults/main.yml   <- переменные (низкий приоритет)
  vars/main.yml       <- константы (высокий приоритет)
  meta/main.yml       <- зависимости

# Использование в плейбуке
roles:
  - role: nginx
  - role: nginx
    vars:
      nginx_port: 8080

# Зависимости
ansible-galaxy install -r requirements.yml
```
