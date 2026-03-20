# Шаг 4: Магические переменные Ansible

Ansible автоматически предоставляет специальные переменные.
Самые полезные: `hostvars`, `groups`, `inventory_hostname`, `ansible_play_hosts`.

## inventory_hostname и ansible_hostname

```bash
cat > ~/ansible-lab/playbooks/magic_vars.yml << 'EOF'
---
- name: Магические переменные
  hosts: all
  become: no
  gather_facts: yes

  tasks:
    - name: inventory_hostname vs ansible_hostname
      debug:
        msg: >
          inventory_hostname: {{ inventory_hostname }}
          (имя в файле инвентаря)
          ansible_hostname: {{ ansible_hostname }}
          (реальное имя хоста по SSH)
          inventory_hostname_short: {{ inventory_hostname_short }}
          (без домена)

    - name: Информация об инвентаре
      debug:
        msg: >
          Группы этого хоста: {{ group_names }}
          Все группы в инвентаре: {{ groups.keys() | list }}
          Все хосты группы webservers: {{ groups['webservers'] | default([]) }}

    - name: Путь к файлам инвентаря
      debug:
        msg: "ansible_play_hosts: {{ ansible_play_hosts }}"
EOF
ansible-playbook ~/ansible-lab/playbooks/magic_vars.yml
```{{execute}}

## hostvars: переменные другого хоста

```bash
cat > ~/ansible-lab/playbooks/hostvars_demo.yml << 'EOF'
---
- name: hostvars — доступ к переменным других хостов
  hosts: all
  become: no
  gather_facts: yes

  tasks:
    - name: Посмотреть IP-адрес node01
      debug:
        msg: >
          IP node01: {{ hostvars['node01']['ansible_default_ipv4']['address'] }}
          ОС node01: {{ hostvars['node01']['ansible_distribution'] }}
      when: "'node01' in hostvars"

    - name: Сформировать строку подключения к БД
      debug:
        msg: >
          DB_HOST={{ hostvars[groups['webservers'][0]]['ansible_default_ipv4']['address'] }}
      when: groups['webservers'] | length > 0
EOF
ansible-playbook ~/ansible-lab/playbooks/hostvars_demo.yml
```{{execute}}

## Специальные переменные для пути и ролей

```bash
cat << 'EOF'
Полезные магические переменные:

  inventory_hostname      имя хоста в инвентаре
  inventory_hostname_short  имя без домена
  group_names             список групп текущего хоста
  groups                  все группы: {'all': [...], 'webservers': [...]}
  hostvars                переменные любого хоста
  ansible_play_hosts      хосты текущего play (без failed)
  ansible_play_batch      хосты текущей партии (serial)
  playbook_dir            директория плейбука
  role_path               путь к текущей роли
  inventory_dir           директория файла инвентаря
EOF
```{{execute}}

```bash
cat > ~/ansible-lab/playbooks/paths_demo.yml << 'EOF'
---
- name: Переменные путей
  hosts: all
  become: no
  gather_facts: no

  tasks:
    - name: Показать пути
      debug:
        msg: >
          playbook_dir: {{ playbook_dir }}
          inventory_dir: {{ inventory_dir }}
EOF
ansible-playbook ~/ansible-lab/playbooks/paths_demo.yml
```{{execute}}
