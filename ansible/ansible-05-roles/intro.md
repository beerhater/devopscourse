# Ansible Roles — структура роли, разбиение плейбука

Роль — это способ организовать плейбук в **переиспользуемые блоки**.
Вместо одного огромного плейбука на 300 строк — набор маленьких ролей.

```
БЕЗ ролей:                     С РОЛЯМИ:
                               roles/
site.yml (300 строк)             nginx/       <- роль nginx
  - tasks: install nginx           tasks/
  - tasks: configure nginx         handlers/
  - tasks: deploy app              templates/
  - tasks: setup user              defaults/
  - tasks: configure firewall      vars/
  - handlers: ...               app/         <- роль app
  - templates: ...              user/         <- роль user
  - vars: ...
                               site.yml (10 строк)
                                 roles: [nginx, app, user]
```

## Что изучим

- Структура директорий роли
- `ansible-galaxy init`: создание роли
- `tasks/main.yml`, `handlers/main.yml`
- `defaults/main.yml` vs `vars/main.yml`
- `templates/` и `files/` внутри роли
- Вызов роли в плейбуке: `roles:`, `include_role:`, `import_role:`
- Зависимости ролей: `meta/main.yml`
- Разбиение большого плейбука на роли
- `ansible-galaxy`: установка ролей из Galaxy

> Проверяем: `cd ~/ansible-lab && ansible all -m ping`{{execute}}
