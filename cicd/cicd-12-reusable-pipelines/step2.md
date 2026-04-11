# Шаг 2: Добавляем inputs в reusable workflow

Reusable workflow становится полезным, когда принимает параметры.

```bash
cat > /root/reusable_inputs.yml <<'EOF'
on:
  workflow_call:
    inputs:
      app-name:
        required: true
        type: string
      deploy-env:
        required: true
        type: string
EOF

cat /root/reusable_inputs.yml
```{{execute}}
