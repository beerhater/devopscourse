# Шаг 6: Собираем production-style шаблон

Сведите reusable workflow и caller к более production-подобному виду.

```bash
cat > /root/reusable_final.yml <<'EOF'
name: caller-final

on:
  push:
    branches: [main]

jobs:
  call-common:
    uses: ./.github/workflows/common-test.yml
    with:
      app-name: payments-api
      deploy-env: production
    secrets: inherit
EOF

cat /root/reusable_final.yml
```{{execute}}
