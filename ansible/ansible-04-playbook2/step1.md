# Шаг 1: Приоритет переменных

Ansible имеет **22 уровня приоритета** переменных. Запомните главное:
чем правее в командной строке или ближе к хосту — тем выше приоритет.

## Иерархия (от низшего к высшему)

```bash
cat << 'EOF'
1.  role defaults           (самый низкий)
2.  inventory group_vars/all
3.  playbook group_vars/all
4.  inventory group_vars/*
5.  playbook group_vars/*
6.  inventory host_vars/*
7.  playbook host_vars/*
8.  host facts (gather_facts)
9.  play vars
10. play vars_prompt
11. play vars_files
12. role vars
13. block vars
14. task vars
15. include_vars
16. set_facts / registered vars
17. role params
18. include params
19. extra vars (-e)          (самый высокий)
EOF
```{{execute}}

## Демонстрация: что побеждает?

```bash
mkdir -p ~/ansible-lab/group_vars ~/ansible-lab/host_vars
cat > ~/ansible-lab/group_vars/all.yml << 'EOF'
color: blue
app_env: development
EOF

cat > ~/ansible-lab/host_vars/node01.yml << 'EOF'
color: green     # переопределяет group_vars/all
EOF
```{{execute}}

```bash
cat > ~/ansible-lab/playbooks/priority_demo.yml << 'EOF'
---
- name: Демонстрация приоритета переменных
  hosts: all
  become: no
  gather_facts: no

  vars:
    color: orange    # play vars переопределяет host_vars

  tasks:
    - name: Какой цвет победил?
      debug:
        msg: "color={{ color }}, app_env={{ app_env }}"
EOF
ansible-playbook ~/ansible-lab/playbooks/priority_demo.yml
```{{execute}}

```bash
# -e наивысший приоритет — побьёт даже play vars
ansible-playbook ~/ansible-lab/playbooks/priority_demo.yml -e "color=red"
```{{execute}}

## Фильтр default: значение если переменная не определена

```bash
cat > ~/ansible-lab/playbooks/default_demo.yml << 'EOF'
---
- name: Фильтр default
  hosts: all
  become: no
  gather_facts: no

  tasks:
    - name: Переменная не определена -> используем default
      debug:
        msg: >
          порт: {{ http_port | default(80) }}
          путь: {{ deploy_path | default('/var/www/html') }}
          имя: {{ app_name | default('myapp') }}

    - name: default(omit) - пропустить аргумент если не задан
      file:
        path: /tmp/test_default
        state: touch
        mode: "{{ file_mode | default(omit) }}"
EOF
ansible-playbook ~/ansible-lab/playbooks/default_demo.yml
```{{execute}}
