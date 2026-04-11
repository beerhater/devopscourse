# Шаг 2: Job-level env

Иногда переменные нужны только одному job.

```bash
cat > /root/cicd_job_env.yml <<'EOF'
jobs:
  deploy:
    runs-on: ubuntu-latest
    env:
      APP_ENV: production
      APP_PORT: "8080"
    steps:
      - run: echo "$APP_ENV $APP_PORT"
EOF

cat /root/cicd_job_env.yml
```{{execute}}
