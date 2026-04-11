# Шаг 3: Цикл внутри шаблона

Шаблон часто должен рендерить список серверов, upstream или портов.

```bash
cd /root/ansible-templates-demo

cat > templates/upstreams.j2 <<'EOF'
{% for host in upstreams %}
server {{ host }};
{% endfor %}
EOF

cat > playbook-upstreams.yml <<'EOF'
- hosts: localhost
  gather_facts: false
  vars:
    upstreams:
      - api-1.internal
      - api-2.internal
  tasks:
    - template:
        src: templates/upstreams.j2
        dest: /tmp/upstreams.conf
EOF

ansible-playbook -i inventory.ini playbook-upstreams.yml
cat /tmp/upstreams.conf > /root/ansible_template_loop.txt
```{{execute}}
