# Шаг 3: Переменные — vars, set_fact, -e

## vars: переменные уровня play

```bash
cat > ~/ansible-lab/playbooks/vars_demo.yml << 'EOF'
---
- name: Демонстрация переменных
  hosts: all
  become: no
  gather_facts: yes

  vars:
    app_name: myapp
    app_version: "2.1.0"
    http_port: 8080
    deploy_path: /opt/myapp

  tasks:
    - name: Показать переменные
      debug:
        msg: >
          Приложение: {{ app_name }} v{{ app_version }}
          Порт: {{ http_port }}
          Путь: {{ deploy_path }}

    - name: Показать факт об ОС (из gather_facts)
      debug:
        msg: "ОС: {{ ansible_distribution }} | RAM: {{ ansible_memtotal_mb }} МБ"

    - name: Составное значение из переменных
      debug:
        msg: "URL: http://{{ inventory_hostname }}:{{ http_port }}/{{ app_name }}"
EOF
ansible-playbook ~/ansible-lab/playbooks/vars_demo.yml
```{{execute}}

## set_fact: вычислять переменные в процессе

```bash
cat > ~/ansible-lab/playbooks/set_fact_demo.yml << 'EOF'
---
- name: Демонстрация set_fact
  hosts: all
  become: no
  gather_facts: yes

  vars:
    base_port: 8000
    app_instance: 1

  tasks:
    - name: Вычислить порт приложения
      set_fact:
        app_port: "{{ base_port | int + app_instance | int }}"
        app_url: "http://{{ ansible_default_ipv4.address }}:{{ base_port | int + app_instance | int }}"

    - name: Показать вычисленные значения
      debug:
        msg: "Порт: {{ app_port }}, URL: {{ app_url }}"
EOF
ansible-playbook ~/ansible-lab/playbooks/set_fact_demo.yml
```{{execute}}

## -e: переменные из командной строки (наивысший приоритет)

```bash
cat > ~/ansible-lab/playbooks/deploy.yml << 'EOF'
---
- name: Плейбук с параметрами
  hosts: all
  become: no
  gather_facts: no

  vars:
    version: "1.0.0"
    env: development

  tasks:
    - name: Показать параметры деплоя
      debug:
        msg: "Деплоим версию {{ version }} в окружение {{ env }}"
EOF
```{{execute}}

```bash
# Запуск с переменными по умолчанию
ansible-playbook ~/ansible-lab/playbooks/deploy.yml
```{{execute}}

```bash
# Переопределяем через -e (extra vars)
ansible-playbook ~/ansible-lab/playbooks/deploy.yml -e "version=2.5.1 env=production"
```{{execute}}

```bash
# -e имеет НАИВЫСШИЙ приоритет — переопределяет vars, group_vars, host_vars
ansible-playbook ~/ansible-lab/playbooks/deploy.yml -e '{"version":"3.0.0","env":"staging"}'
```{{execute}}
