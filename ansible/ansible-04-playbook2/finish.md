# Модуль завершён!

## Что изучили

- **Приоритет переменных** -- 19 уровней, `-e` побеждает всегда
- **`vars_files`** -- загрузка из YAML-файлов, динамические имена файлов
- **`register`** -- захватить stdout/rc/changed, использовать в `when`
- **Магические переменные** -- `hostvars`, `groups`, `inventory_hostname`, `group_names`
- **Jinja2 фильтры** -- `default`, `upper/lower`, `join`, `selectattr`, `map`, `combine`
- **`{% for %}`** -- генерация повторяющихся блоков в шаблонах
- **`{% if %}`** -- условные секции в шаблонах
- **`failed_when`** -- переопределить условие провала задачи
- **`changed_when`** -- переопределить условие changed (важно для идемпотентности)
- **`ignore_errors`** -- продолжить при ошибке
- **`block/rescue/always`** -- try/except/finally для групп задач

## Шпаргалка Jinja2

```jinja2
{{ var | default('fallback') }}          значение по умолчанию
{{ var | upper | trim }}                 цепочка фильтров
{{ list | join(', ') }}                  список в строку
{{ list | selectattr('enabled','eq',true) | map(attribute='name') | list }}
{% for item in list %}{{ item }}{% endfor %}
{% if condition %}...{% elif other %}...{% else %}...{% endif %}
```

## Следующий модуль

**Roles** -- структура роли, `defaults/main.yml`, `tasks/main.yml`, `handlers/main.yml`,
`templates/`, `ansible-galaxy init`, зависимости через `meta/main.yml`.
