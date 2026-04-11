# Шаг 5: Разделяем non-sensitive и secret values

Соберите короткий шаблон, где видно, что именно считается секретом.

```bash
cat > /root/cicd_secret_split.yml <<'EOF'
env:
  APP_ENV: production
  REGISTRY_USER: deploy-bot

jobs:
  publish:
    runs-on: ubuntu-latest
    steps:
      - env:
          REGISTRY_PASSWORD: ${{ secrets.REGISTRY_PASSWORD }}
        run: echo "Secret comes from secrets context"
EOF

cat /root/cicd_secret_split.yml
```{{execute}}
