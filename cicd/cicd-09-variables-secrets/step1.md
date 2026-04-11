# Шаг 1: Переменные и secrets в workflow

Создайте workflow, где обычные переменные и secret используются по-разному.

```bash
mkdir -p /root/cicd-vars/.github/workflows

cat > /root/cicd-vars/.github/workflows/vars-secrets.yml <<'EOF'
name: vars-and-secrets

on:
  workflow_dispatch:

env:
  APP_ENV: production
  APP_PORT: "8080"

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - name: Print non-sensitive vars
        run: echo "Deploying to $APP_ENV on port $APP_PORT"
      - name: Use registry password safely
        env:
          REGISTRY_PASSWORD: ${{ secrets.REGISTRY_PASSWORD }}
        run: echo "Secret is passed through env but not hardcoded"
EOF

cp /root/cicd-vars/.github/workflows/vars-secrets.yml /root/cicd_vars_result.yml
cat /root/cicd_vars_result.yml
```{{execute}}

Смысл урока:

- обычные значения можно хранить как `env`;
- чувствительные данные должны приезжать через `secrets`.
