# Шаг 4: default filter для значений по умолчанию

Иногда переменная может не прийти, и тогда шаблон должен использовать safe default.

```bash
cd /root/ansible-templates-demo

cat > templates/defaults.conf.j2 <<'EOF'
LOG_LEVEL={{ log_level | default('info') }}
EOF

cat > playbook-defaults.yml <<'EOF'
- hosts: localhost
  gather_facts: false
  tasks:
    - template:
        src: templates/defaults.conf.j2
        dest: /tmp/defaults.conf
EOF

ansible-playbook -i inventory.ini playbook-defaults.yml
cat /tmp/defaults.conf > /root/ansible_template_default.txt
```{{execute}}
