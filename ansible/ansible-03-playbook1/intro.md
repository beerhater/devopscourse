# Ansible Playbook. Часть 1

Ad-hoc команды отлично подходят для разовых задач.
Но когда нужно выполнить **серию действий воспроизводимо** — нужен плейбук.

```
Ad-hoc:   ansible all -m apt -a "name=nginx state=present"
          ansible all -m copy -a "src=... dest=..."
          ansible all -m service -a "name=nginx state=started"
          3 команды, ручное выполнение, не версионируется

Playbook: ansible-playbook nginx.yml
          1 команда, декларативно, в git, повторяемо
```

## Что изучим

- Структура YAML-плейбука: play, hosts, tasks
- Первый плейбук: установка пакетов
- Переменные: `vars`, `set_fact`, `-e` из командной строки
- Условия: `when`
- Циклы: `loop`
- **Handlers и `notify`**: умный перезапуск сервисов
- Теги: `tags`, запуск избранных задач
- `template`: Jinja2-шаблоны для конфигов
- Флаги `ansible-playbook`: `--check`, `--diff`, `--limit`, `--tags`
- Итоговое задание: полный provision nginx

> Проверяем настройку: `cd ~/ansible-lab && ansible all -m ping`{{execute}}
