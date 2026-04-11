# Шаг 2: Условие внутри шаблона

Jinja2 полезен не только подстановкой переменных, но и условиями.

```bash
cd /root/ansible-templates-demo

cat > templates/feature.conf.j2 <<'EOF'
APP_NAME={{ app_name }}
{% if feature_metrics %}
FEATURE_METRICS=enabled
{% else %}
FEATURE_METRICS=disabled
{% endif %}
EOF

cat > playbook-feature.yml <<'EOF'
- hosts: localhost
  gather_facts: false
  vars:
    app_name: payments-api
    feature_metrics: true
  tasks:
    - template:
        src: templates/feature.conf.j2
        dest: /tmp/feature.conf
EOF

ansible-playbook -i inventory.ini playbook-feature.yml
cat /tmp/feature.conf > /root/ansible_template_conditional.txt
```{{execute}}
