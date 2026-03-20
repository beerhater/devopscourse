# Шаг 1: Структура YAML-плейбука

Плейбук — это YAML-файл со списком **play**.
Каждый play описывает: на **каких хостах** выполнять и **какие задачи (tasks)** запустить.

## Анатомия плейбука

```yaml
---                         # начало YAML-документа (опционально, хорошая практика)
- name: Имя play            # описание play (что делаем)
  hosts: webservers         # кого затронуть (из инвентаря)
  become: yes               # выполнять от root (sudo)

  vars:                     # переменные уровня play
    http_port: 80

  tasks:                    # список задач (выполняются сверху вниз)
    - name: Установить nginx # описание задачи
      apt:                  # модуль Ansible
        name: nginx
        state: present

    - name: Запустить nginx
      service:
        name: nginx
        state: started
```

## Создаём рабочую директорию

```bash
mkdir -p ~/ansible-lab/playbooks
cd ~/ansible-lab
```{{execute}}

## Пишем минимальный плейбук

```bash
cat > ~/ansible-lab/playbooks/hello.yml << 'EOF'
---
- name: Первый плейбук
  hosts: all
  become: no

  tasks:
    - name: Вывести приветствие
      debug:
        msg: "Привет от Ansible! Хост: {{ inventory_hostname }}"

    - name: Показать информацию об ОС
      debug:
        msg: "ОС: {{ ansible_distribution }} {{ ansible_distribution_version }}"
EOF
cat ~/ansible-lab/playbooks/hello.yml
```{{execute}}

## Запускаем первый плейбук

```bash
cd ~/ansible-lab
ansible-playbook playbooks/hello.yml
```{{execute}}

## Что означает вывод

```bash
cat << 'EOF'
PLAY [Первый плейбук]       <- название play
TASK [Gathering Facts]      <- автоматический сбор фактов (setup)
ok: [node01]

TASK [Вывести приветствие]
ok: [node01]

PLAY RECAP                  <- итог
node01: ok=3  changed=0  unreachable=0  failed=0
        |          |           |              |
    выполнено  изменений  недоступно    ошибок
EOF
```{{execute}}

```bash
# Запуск с флагом -v: подробный вывод каждой задачи
ansible-playbook playbooks/hello.yml -v
```{{execute}}
