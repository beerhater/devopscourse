# Шаг 4: Подключаем secrets: inherit

Если caller already manages secrets, иногда проще пробросить их целиком.

```bash
cat > /root/reusable_secrets_inherit.yml <<'EOF'
jobs:
  call-common:
    uses: ./.github/workflows/common-test.yml
    secrets: inherit
EOF

cat /root/reusable_secrets_inherit.yml
```{{execute}}
