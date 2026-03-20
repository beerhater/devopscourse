# Шаг 5: Циклы — loop

`loop` позволяет повторить задачу для каждого элемента списка.

## Базовый цикл loop

```bash
cat > ~/ansible-lab/playbooks/loop_demo.yml << 'EOF'
---
- name: Демонстрация циклов
  hosts: all
  become: yes
  gather_facts: no

  tasks:
    - name: Установить несколько пакетов
      apt:
        name: "{{ item }}"
        state: present
        update_cache: yes
      loop:
        - curl
        - wget
        - tree
        - htop

    - name: Создать несколько директорий
      file:
        path: "{{ item }}"
        state: directory
        mode: '0755'
      loop:
        - /opt/app
        - /opt/app/logs
        - /opt/app/config
        - /opt/app/tmp

    - name: Показать список
      debug:
        msg: "Обрабатываю элемент: {{ item }}"
      loop:
        - первый
        - второй
        - третий
EOF
ansible-playbook ~/ansible-lab/playbooks/loop_demo.yml
```{{execute}}

## Цикл по словарям

```bash
cat > ~/ansible-lab/playbooks/loop_dict.yml << 'EOF'
---
- name: Цикл по словарям
  hosts: all
  become: yes
  gather_facts: no

  tasks:
    - name: Создать пользователей
      user:
        name: "{{ item.name }}"
        comment: "{{ item.comment }}"
        state: present
        create_home: yes
      loop:
        - { name: alice, comment: "Разработчик Alice" }
        - { name: bob,   comment: "Девопс Bob" }

    - name: Показать созданных пользователей
      command: "id {{ item }}"
      loop:
        - alice
        - bob

    - name: Удалить тестовых пользователей
      user:
        name: "{{ item }}"
        state: absent
        remove: yes
      loop:
        - alice
        - bob
EOF
ansible-playbook ~/ansible-lab/playbooks/loop_dict.yml
```{{execute}}

## loop_control: именуем итерационную переменную

```bash
cat > ~/ansible-lab/playbooks/loop_control.yml << 'EOF'
---
- name: Управление циклом
  hosts: all
  become: no
  gather_facts: no

  tasks:
    - name: Задача с именованной переменной цикла
      debug:
        msg: "Пакет #{{ loop_idx + 1 }}: {{ pkg }}"
      loop:
        - nginx
        - curl
        - git
      loop_control:
        loop_var: pkg          # переименовать item -> pkg
        index_var: loop_idx    # переменная с индексом (0, 1, 2...)
        label: "{{ pkg }}"     # что показывать в выводе
EOF
ansible-playbook ~/ansible-lab/playbooks/loop_control.yml
```{{execute}}
