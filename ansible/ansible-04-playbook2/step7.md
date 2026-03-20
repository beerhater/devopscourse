# Шаг 7: Углублённое when — failed_when, changed_when, ignore_errors

## failed_when: переопределить когда задача считается провалившейся

```bash
cat > ~/ansible-lab/playbooks/failed_when.yml << 'EOF'
---
- name: failed_when и changed_when
  hosts: all
  become: no
  gather_facts: no

  tasks:
    # Обычно: ненулевой rc = FAILED
    # failed_when: считаем провалом только если в выводе есть "CRITICAL"
    - name: Проверить лог (провал только при CRITICAL)
      shell: "echo 'WARNING: disk space low'"
      register: log_check
      failed_when: "'CRITICAL' in log_check.stdout"

    - name: Эта задача выполнится (WARNING != CRITICAL)
      debug:
        msg: "Лог проверен, критических ошибок нет"

    # grep возвращает rc=1 если ничего не найдено — это не ошибка!
    - name: Проверить наличие пользователя (rc=1 — это нормально)
      shell: "grep -c '^nobody:' /etc/passwd"
      register: user_check
      failed_when: user_check.rc > 1   # провал только при rc > 1 (реальная ошибка)

    - name: Результат проверки пользователя
      debug:
        msg: "nobody найден: {{ user_check.stdout | int > 0 }}"
EOF
ansible-playbook ~/ansible-lab/playbooks/failed_when.yml
```{{execute}}

## changed_when: переопределить когда задача считается изменившей хост

```bash
cat > ~/ansible-lab/playbooks/changed_when.yml << 'EOF'
---
- name: changed_when — точный контроль идемпотентности
  hosts: all
  become: no
  gather_facts: no

  tasks:
    # shell/command всегда возвращают changed=true
    # changed_when: false говорит "эта задача ничего не меняет"
    - name: Показать статус nginx (только чтение)
      command: systemctl is-active nginx
      register: nginx_status
      changed_when: false   # это read-only операция

    - debug:
        msg: "nginx: {{ nginx_status.stdout }}"

    # Считать задачу изменившей состояние только если вывод содержит "updated"
    - name: Обновить что-нибудь (changed только при реальном обновлении)
      shell: |
        if [ ! -f /tmp/marker ]; then
          touch /tmp/marker
          echo "updated"
        else
          echo "already done"
        fi
      register: update_result
      changed_when: "'updated' in update_result.stdout"

    - debug:
        msg: "Задача выполнена: changed={{ update_result.changed }}"
EOF
ansible-playbook ~/ansible-lab/playbooks/changed_when.yml
```{{execute}}

```bash
# Второй запуск: changed=False (уже сделано)
ansible-playbook ~/ansible-lab/playbooks/changed_when.yml
```{{execute}}

## ignore_errors: продолжить при ошибке

```bash
cat > ~/ansible-lab/playbooks/ignore_errors.yml << 'EOF'
---
- name: ignore_errors
  hosts: all
  become: no
  gather_facts: no

  tasks:
    - name: Эта команда упадёт
      command: "ls /несуществующий_путь"
      register: fail_result
      ignore_errors: yes   # продолжаем несмотря на ошибку

    - name: Эта задача выполнится несмотря на предыдущую ошибку
      debug:
        msg: "Ошибка была проигнорирована: {{ fail_result.failed }}"

    - name: Продолжаем работу...
      command: hostname
EOF
ansible-playbook ~/ansible-lab/playbooks/ignore_errors.yml
```{{execute}}
