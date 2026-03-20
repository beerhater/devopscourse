# Шаг 9: Флаги ansible-playbook

## --check: режим dry-run (без реальных изменений)

```bash
cd ~/ansible-lab

# Симуляция: показывает, что ИЗМЕНИТСЯ, не применяя
ansible-playbook playbooks/install_nginx.yml --check
```{{execute}}

```bash
# --check + --diff: показывает разницу в файлах
ansible-playbook playbooks/template_demo.yml --check --diff
```{{execute}}

## --diff: показывает изменения в файлах

```bash
# Изменим шаблон и запустим с --diff чтобы увидеть разницу
sed -i 's/OK/HEALTHY/' ~/ansible-lab/templates/nginx.conf.j2
ansible-playbook playbooks/template_demo.yml --diff
```{{execute}}

```bash
# Откатим изменение
sed -i 's/HEALTHY/OK/' ~/ansible-lab/templates/nginx.conf.j2
```{{execute}}

## --limit: запуск на подмножестве хостов

```bash
# Запустить только на node01 (даже если hosts: all)
ansible-playbook playbooks/install_nginx.yml --limit node01
```{{execute}}

```bash
# Запустить только на группе webservers
ansible-playbook playbooks/install_nginx.yml --limit webservers
```{{execute}}

## --tags и --skip-tags

```bash
# Запустить только задачи с тегом config
ansible-playbook playbooks/tagged.yml --tags config
```{{execute}}

```bash
# Пропустить задачи с тегом install
ansible-playbook playbooks/tagged.yml --skip-tags install
```{{execute}}

## --list-hosts, --list-tasks, --list-tags

```bash
# Показать, на каких хостах выполнится плейбук
ansible-playbook playbooks/install_nginx.yml --list-hosts
```{{execute}}

```bash
# Показать список задач без запуска
ansible-playbook playbooks/tagged.yml --list-tasks
```{{execute}}

## -v / -vv / -vvv: уровни детализации

```bash
cat << 'EOF'
-v    показывает результат каждой задачи
-vv   показывает входные и выходные данные модуля
-vvv  показывает SSH-соединение и вызовы модулей
-vvvv показывает всё (для отладки подключения)
EOF
```{{execute}}

```bash
ansible-playbook playbooks/hello.yml -v
```{{execute}}
