# Шаг 1: Структура роли

## Что такое роль

Роль — это набор файлов в **стандартной структуре директорий**.
Ansible автоматически подхватывает файлы из нужных мест.

## Стандартная структура директорий

```bash
cat << 'EOF'
roles/
  my_role/
    tasks/
      main.yml       <- ОБЯЗАТЕЛЬНО: список задач роли
    handlers/
      main.yml       <- обработчики (notify)
    templates/
      *.j2           <- Jinja2-шаблоны
    files/
      *              <- статические файлы (copy)
    vars/
      main.yml       <- переменные с ВЫСОКИМ приоритетом
    defaults/
      main.yml       <- переменные с НИЗКИМ приоритетом (переопределяемые)
    meta/
      main.yml       <- зависимости роли, метаданные
    README.md        <- документация
EOF
```{{execute}}

## Где Ansible ищет роли

```bash
cat << 'EOF'
Порядок поиска:
  1. ./roles/           (рядом с плейбуком)
  2. ~/.ansible/roles/  (пользовательские роли)
  3. /etc/ansible/roles/ (системные роли)
  4. roles_path в ansible.cfg

Лучшая практика:
  Держите roles/ в директории проекта рядом с site.yml
EOF
```{{execute}}

## Создаём структуру проекта

```bash
mkdir -p ~/ansible-roles-lab
cd ~/ansible-roles-lab
cp ~/ansible-lab/ansible.cfg .
cp ~/ansible-lab/hosts.yml .
mkdir -p roles
```{{execute}}

```bash
# Посмотрим что в нашем ansible.cfg
cat ansible.cfg
```{{execute}}

## Разница: defaults vs vars

```bash
cat << 'EOF'
defaults/main.yml  <- НИЗКИЙ приоритет
  Здесь: значения по умолчанию, которые пользователь ДОЛЖЕН иметь возможность
         переопределить через vars, group_vars, -e
  Например: nginx_port: 80, app_user: www-data

vars/main.yml      <- ВЫСОКИЙ приоритет
  Здесь: внутренние константы роли, которые НЕ должны меняться снаружи
  Например: _nginx_conf_dir: /etc/nginx/conf.d

Правило: почти всегда используйте defaults/
         vars/ только для внутренних констант роли
EOF
```{{execute}}
