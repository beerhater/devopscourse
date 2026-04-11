# Шаг 7: Формируем template-checklist

```bash
cat > /root/ansible_template_checklist.txt <<'EOF'
variables_in_templates=yes
conditionals_in_templates=yes
loops_in_templates=yes
defaults_for_missing_values=yes
EOF

cat /root/ansible_template_checklist.txt
```{{execute}}
