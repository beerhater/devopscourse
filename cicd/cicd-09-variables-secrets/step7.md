# Шаг 7: Формируем security-checklist

Зафиксируйте базовые правила работы с переменными и секретами.

```bash
cat > /root/cicd_vars_checklist.txt <<'EOF'
plain_env_for_non_sensitive=yes
secrets_context_for_passwords=yes
github_env_for_runtime_values=yes
no_hardcoded_passwords=yes
EOF

cat /root/cicd_vars_checklist.txt
```{{execute}}
