# Шаг 5: Делаем caller с параметрами

Теперь оформим более содержательный caller.

```bash
cat > /root/reusable_caller_params.yml <<'EOF'
jobs:
  call-common:
    uses: ./.github/workflows/common-test.yml
    with:
      app-name: payments-api
      deploy-env: production
EOF

cat /root/reusable_caller_params.yml
```{{execute}}
