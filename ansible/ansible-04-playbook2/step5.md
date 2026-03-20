# Шаг 5: Jinja2 фильтры

Фильтры трансформируют значения переменных: `{{ переменная | фильтр }}`.

## Строковые фильтры

```bash
cat > ~/ansible-lab/playbooks/filters_str.yml << 'EOF'
---
- name: Строковые фильтры Jinja2
  hosts: all
  become: no
  gather_facts: no

  vars:
    app_name: "  My Ansible App  "
    version: "v2.1.0-beta"
    path: "/var/www/html/index.html"

  tasks:
    - name: Трансформации строк
      debug:
        msg: >
          upper: {{ app_name | upper }}
          lower: {{ app_name | lower }}
          trim: '{{ app_name | trim }}'
          replace: {{ version | replace('-beta','') }}
          basename: {{ path | basename }}
          dirname: {{ path | dirname }}
          length: {{ app_name | length }}

    - name: Шаблонизация строк
      debug:
        msg: >
          title: {{ app_name | trim | title }}
          regex_replace: {{ version | regex_replace('^v','') }}
          truncate: {{ app_name | trim | truncate(5) }}
EOF
ansible-playbook ~/ansible-lab/playbooks/filters_str.yml
```{{execute}}

## Числовые и булевы фильтры

```bash
cat > ~/ansible-lab/playbooks/filters_num.yml << 'EOF'
---
- name: Числовые и булевы фильтры
  hosts: all
  become: no
  gather_facts: yes

  vars:
    ram_mb: "{{ ansible_memtotal_mb }}"
    debug_flag: "true"

  tasks:
    - name: Числовые операции
      debug:
        msg: >
          ram_mb: {{ ram_mb | int }}
          ram_gb: {{ (ram_mb | int / 1024) | round(1) }}
          bool из строки: {{ debug_flag | bool }}
          abs(-42): {{ -42 | abs }}
          max(1,2,3): {{ [1, 2, 3] | max }}
          min(1,2,3): {{ [1, 2, 3] | min }}
EOF
ansible-playbook ~/ansible-lab/playbooks/filters_num.yml
```{{execute}}

## Фильтры для списков

```bash
cat > ~/ansible-lab/playbooks/filters_list.yml << 'EOF'
---
- name: Фильтры для списков
  hosts: all
  become: no
  gather_facts: no

  vars:
    packages:
      - nginx
      - curl
      - wget
      - tree
    servers:
      - { name: web1, port: 80, enabled: true }
      - { name: web2, port: 8080, enabled: false }
      - { name: api1, port: 3000, enabled: true }

  tasks:
    - name: Операции со списком
      debug:
        msg: >
          join: {{ packages | join(', ') }}
          sort: {{ packages | sort | join(', ') }}
          unique: {{ ['a','b','a','c'] | unique | join(',') }}
          length: {{ packages | length }}
          first: {{ packages | first }}
          last: {{ packages | last }}

    - name: Фильтрация списка словарей
      debug:
        msg: >
          включённые: {{ servers | selectattr('enabled','equalto',true) | map(attribute='name') | list }}
          порты: {{ servers | map(attribute='port') | list }}
EOF
ansible-playbook ~/ansible-lab/playbooks/filters_list.yml
```{{execute}}

## Фильтры для словарей и JSON

```bash
cat > ~/ansible-lab/playbooks/filters_dict.yml << 'EOF'
---
- name: Фильтры для словарей и JSON
  hosts: all
  become: no
  gather_facts: no

  vars:
    config:
      host: localhost
      port: 5432
      name: mydb

  tasks:
    - name: Работа со словарём
      debug:
        msg: >
          keys: {{ config.keys() | list }}
          values: {{ config.values() | list }}
          to_json: {{ config | to_json }}
          to_nice_json: есть в ansible
          combine: {{ config | combine({'port': 3306}) }}
EOF
ansible-playbook ~/ansible-lab/playbooks/filters_dict.yml
```{{execute}}
