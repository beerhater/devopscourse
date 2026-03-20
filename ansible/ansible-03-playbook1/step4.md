# Шаг 4: Условия — when

`when` позволяет выполнять задачу только при выполнении условия.
Используется для: разных дистрибутивов, окружений, флагов включения.

## Базовый синтаксис when

```bash
cat > ~/ansible-lab/playbooks/when_demo.yml << 'EOF'
---
- name: Демонстрация условий when
  hosts: all
  become: yes
  gather_facts: yes

  vars:
    install_curl: true
    env: production

  tasks:
    - name: Установить curl (только если включено)
      apt:
        name: curl
        state: present
      when: install_curl == true

    - name: Задача только для Debian/Ubuntu
      debug:
        msg: "Это Debian-семейство: {{ ansible_distribution }}"
      when: ansible_os_family == "Debian"

    - name: Задача только для RedHat (пропустится в нашей лаборатории)
      debug:
        msg: "Это RedHat-семейство"
      when: ansible_os_family == "RedHat"

    - name: Показать предупреждение только для production
      debug:
        msg: "ВНИМАНИЕ: деплоим в продакшен!"
      when: env == "production"

    - name: Проверить достаточно ли RAM
      debug:
        msg: "RAM достаточно: {{ ansible_memtotal_mb }} МБ"
      when: ansible_memtotal_mb >= 512
EOF
ansible-playbook ~/ansible-lab/playbooks/when_demo.yml
```{{execute}}

## when с несколькими условиями

```bash
cat > ~/ansible-lab/playbooks/when_multi.yml << 'EOF'
---
- name: Несколько условий
  hosts: all
  become: no
  gather_facts: yes

  tasks:
    - name: Условие И (оба должны быть истинны)
      debug:
        msg: "Ubuntu и достаточно RAM"
      when:
        - ansible_distribution == "Ubuntu"
        - ansible_memtotal_mb >= 256

    - name: Условие ИЛИ
      debug:
        msg: "Ubuntu или Debian"
      when: ansible_distribution == "Ubuntu" or ansible_distribution == "Debian"

    - name: Проверка с register
      command: systemctl is-active nginx
      register: nginx_status
      ignore_errors: yes

    - name: Показать статус nginx
      debug:
        msg: "nginx активен"
      when: nginx_status.rc == 0
EOF
ansible-playbook ~/ansible-lab/playbooks/when_multi.yml
```{{execute}}
