# Модуль завершён!

## Что изучили

- **Синтаксис ad-hoc** -- `ansible <паттерн> -m <модуль> -a <аргументы>`
- **-m command** -- модуль по умолчанию, без возможностей оболочки
- **-m shell** -- полная оболочка: конвейеры, перенаправления, переменные
- **-m raw** -- без Python, чистый SSH (для начальной настройки)
- **-m apt** -- установка/удаление/обновление пакетов, идемпотентно
- **-m copy** -- доставка файлов с правами, backup=yes, content=
- **-m file** -- директории, симлинки, права, state=absent
- **-m service / systemd** -- started, stopped, restarted, enabled
- **-m user / group** -- создание пользователей ОС с SSH-ключами
- **-m fetch** -- скачивание файлов С удалённого хоста
- **-m lineinfile** -- добавление/удаление/замена строк в файлах
- **-m replace** -- замена по регулярному выражению во всём файле

## Шпаргалка

```bash
ansible all -m ping
ansible all -m command -a 'uptime'
ansible all -m shell -a 'df -h | grep /'
ansible all -b -m apt -a 'name=nginx state=present update_cache=yes'
ansible all -b -m copy -a 'src=file.txt dest=/tmp/file.txt'
ansible all -b -m copy -a 'content=hello dest=/tmp/f'
ansible all -b -m file -a 'path=/opt/app state=directory mode=0755'
ansible all -b -m service -a 'name=nginx state=started enabled=yes'
ansible all -b -m user -a 'name=deploy state=present create_home=yes'
ansible all -b -m fetch -a 'src=/etc/hostname dest=/tmp/ flat=yes'
ansible all -b -m lineinfile -a 'path=/etc/hosts line=10.0.0.1 myapp'
```

## Следующий модуль

**Playbook. Часть 1** -- YAML-плейбуки, tasks, handlers, `notify`, установка nginx правильно.
