# Шаг 3: Добавляем outputs

Reusable workflow может не только принимать данные, но и возвращать их наружу.

```bash
cat > /root/reusable_outputs.yml <<'EOF'
on:
  workflow_call:
    outputs:
      image-tag:
        description: "Built image tag"
        value: ${{ jobs.build.outputs.image-tag }}
EOF

cat /root/reusable_outputs.yml
```{{execute}}
