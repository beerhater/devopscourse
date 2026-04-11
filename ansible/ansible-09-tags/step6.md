# Шаг 6: Собираем production-style tagged playbook

```bash
cd /root/ansible-tags-demo

cat > playbook-final-tags.yml <<'EOF'
- hosts: localhost
  gather_facts: false
  tasks:
    - name: Install packages
      debug:
        msg: "packages"
      tags: [packages]

    - name: Render config
      debug:
        msg: "config"
      tags: [config]

    - name: Restart service
      debug:
        msg: "restart"
      tags: [deploy]
EOF

cat playbook-final-tags.yml > /root/ansible_tags_final.yml
```{{execute}}
