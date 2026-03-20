# Шаг 3: register — захват вывода задачи

`register` сохраняет результат выполнения задачи в переменную.
Потом можно использовать в `when`, `debug`, `set_fact` и других задачах.

## Что хранится в зарегистрированной переменной

```bash
cat > ~/ansible-lab/playbooks/register_demo.yml << 'EOF'
---
- name: Демонстрация register
  hosts: all
  become: no
  gather_facts: no

  tasks:
    - name: Выполнить команду и сохранить результат
      command: hostname
      register: hostname_result

    - name: Посмотреть структуру результата
      debug:
        var: hostname_result

    - name: Использовать отдельные поля
      debug:
        msg: >
          stdout: {{ hostname_result.stdout }}
          rc (код возврата): {{ hostname_result.rc }}
          changed: {{ hostname_result.changed }}
EOF
ansible-playbook ~/ansible-lab/playbooks/register_demo.yml
```{{execute}}

## register + when: условие по результату

```bash
cat > ~/ansible-lab/playbooks/register_when.yml << 'EOF'
---
- name: register + when
  hosts: all
  become: yes
  gather_facts: no

  tasks:
    - name: Проверить, запущен ли nginx
      command: systemctl is-active nginx
      register: nginx_status
      ignore_errors: yes    # не падать если nginx не запущен

    - name: Запустить nginx если не запущен
      service:
        name: nginx
        state: started
      when: nginx_status.rc != 0

    - name: Показать статус
      debug:
        msg: >
          nginx был {{ 'запущен' if nginx_status.rc == 0 else 'остановлен' }},
          задача запуска {{ 'пропущена' if nginx_status.rc == 0 else 'выполнена' }}

    - name: Проверить версию nginx
      command: nginx -v
      register: nginx_version
      ignore_errors: yes

    - name: Показать версию nginx
      debug:
        msg: "{{ nginx_version.stderr }}"
      when: nginx_version.rc == 0
EOF
ansible-playbook ~/ansible-lab/playbooks/register_when.yml
```{{execute}}

## stdout_lines: список строк вывода

```bash
cat > ~/ansible-lab/playbooks/stdout_lines.yml << 'EOF'
---
- name: stdout_lines — обработка многострочного вывода
  hosts: all
  become: no
  gather_facts: no

  tasks:
    - name: Получить список процессов
      shell: "ps aux | grep nginx | grep -v grep"
      register: nginx_procs
      ignore_errors: yes

    - name: Количество процессов nginx
      debug:
        msg: "Найдено процессов nginx: {{ nginx_procs.stdout_lines | length }}"
      when: nginx_procs.rc == 0

    - name: Показать каждый процесс
      debug:
        msg: "Процесс: {{ item }}"
      loop: "{{ nginx_procs.stdout_lines }}"
      when: nginx_procs.rc == 0 and nginx_procs.stdout_lines | length > 0
EOF
ansible-playbook ~/ansible-lab/playbooks/stdout_lines.yml
```{{execute}}
