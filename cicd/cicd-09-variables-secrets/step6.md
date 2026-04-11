# Шаг 6: Собираем безопасный workflow

Теперь сведём переменные и secrets в один более аккуратный workflow.

```bash
cat > /root/cicd_vars_secure.yml <<'EOF'
name: secure-vars

on:
  workflow_dispatch:

env:
  APP_ENV: production

jobs:
  deploy:
    runs-on: ubuntu-latest
    env:
      APP_PORT: "8080"
    steps:
      - name: Prepare tag
        run: echo "IMAGE_TAG=release-42" >> $GITHUB_ENV
      - name: Deploy
        env:
          REGISTRY_PASSWORD: ${{ secrets.REGISTRY_PASSWORD }}
        run: echo "Deploying $APP_ENV:$APP_PORT with $IMAGE_TAG"
EOF

cat /root/cicd_vars_secure.yml
```{{execute}}
