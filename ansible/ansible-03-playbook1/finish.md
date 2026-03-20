# Модуль завершён!

## Что изучили

- **Структура плейбука** -- `---`, play, `hosts`, `become`, `gather_facts`, `tasks`
- **Идемпотентность** -- второй запуск changed=0, состояние уже желаемое
- **Переменные** -- `vars`, `set_fact`, `-e` из командной строки
- **Условия** -- `when`: один факт, несколько условий, `register`
- **Циклы** -- `loop`, цикл по словарям, `loop_control`
- **Handlers** -- запускаются один раз в конце play при `notify`
- **`listen`** -- один handler слушает несколько задач
- **Template** -- Jinja2 `{{ }}`, `{% if %}`, `{% for %}` в конфигах
- **Теги** -- `--tags`, `--skip-tags`, `--list-tasks`, `--list-tags`
- **Флаги** -- `--check`, `--diff`, `--limit`, `-v/-vv/-vvv`

## Шпаргалка

```bash
# Запуск
ansible-playbook site.yml
ansible-playbook site.yml -i hosts.yml

# Без изменений (dry-run)
ansible-playbook site.yml --check --diff

# Только часть хостов
ansible-playbook site.yml --limit node01

# Только задачи с тегом
ansible-playbook site.yml --tags config
ansible-playbook site.yml --skip-tags install

# Переменная из командной строки
ansible-playbook site.yml -e "env=staging version=2.0"

# Отладка
ansible-playbook site.yml -v
ansible-playbook site.yml --list-tasks
ansible-playbook site.yml --list-hosts
```

## Следующий модуль

**Playbook. Часть 2** -- `register`, `block/rescue/always`, `import_tasks`, `include_tasks`, `pre_tasks`, `post_tasks`.
