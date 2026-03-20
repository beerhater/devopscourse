# Шаг 8: block / rescue / always

`block` группирует задачи. `rescue` выполняется при ошибке. `always` выполняется всегда.
Это аналог try/except/finally из Python.

```
block:    <- попробовать выполнить (try)
  - task1
  - task2
rescue:   <- выполнить при ошибке в block (except)
  - task3
always:   <- выполнить всегда (finally)
  - task4
```

## Базовый block / rescue / always

```bash
cat > ~/ansible-lab/playbooks/block_demo.yml << 'EOF'
---
- name: Демонстрация block/rescue/always
  hosts: all
  become: yes
  gather_facts: no

  tasks:
    - name: Блок с обработкой ошибок
      block:
        - name: Задача 1 (успешная)
          command: hostname
          register: h
        - debug: msg="Хост: {{ h.stdout }}"

        - name: Задача 2 (упадёт)
          command: "ls /несуществующий_путь"

        - name: Задача 3 (НЕ выполнится — блок прерван)
          debug:
            msg: "Эта задача не выполнится"

      rescue:
        - name: Обработка ошибки
          debug:
            msg: "Что-то пошло не так! Выполняем откат..."

        - name: Откат: убедимся что nginx работает
          service:
            name: nginx
            state: started
          ignore_errors: yes

      always:
        - name: Финальная проверка (выполняется всегда)
          debug:
            msg: "Блок завершён. Проверяем состояние системы..."
EOF
ansible-playbook ~/ansible-lab/playbooks/block_demo.yml
```{{execute}}

## Переменные уровня block + when для блока

```bash
cat > ~/ansible-lab/playbooks/block_vars.yml << 'EOF'
---
- name: Переменные и условия на уровне block
  hosts: all
  become: yes
  gather_facts: yes

  tasks:
    - name: Блок установки (только Debian/Ubuntu)
      block:
        - name: Обновить кеш apt
          apt:
            update_cache: yes

        - name: Установить пакеты
          apt:
            name: [curl, wget]
            state: present

      when: ansible_os_family == "Debian"
      become: yes    # become на весь блок

    - name: Блок установки (только RedHat)
      block:
        - name: Установить пакеты через yum
          yum:
            name: [curl, wget]
            state: present
      when: ansible_os_family == "RedHat"
      become: yes
EOF
ansible-playbook ~/ansible-lab/playbooks/block_vars.yml
```{{execute}}
