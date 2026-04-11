## Скрипт читает переменные окружения

Теперь создадим простой скрипт, который печатает значения переменных окружения.

```bash
mkdir -p /opt/env-lab/bin

cat > /opt/env-lab/bin/release-summary.sh <<'EOF'
#!/bin/bash
echo "APP_NAME=${APP_NAME:-unset}"
echo "APP_ENV=${APP_ENV:-unset}"
echo "APP_PORT=${APP_PORT:-unset}"
EOF

chmod +x /opt/env-lab/bin/release-summary.sh

export APP_NAME=platform-api
export APP_ENV=staging
export APP_PORT=8080

/opt/env-lab/bin/release-summary.sh > /root/runtime_summary.txt
cat /root/runtime_summary.txt
```{{execute}}

Это простой, но очень показательный момент:
скрипт ничего не знает о конфиге заранее, он читает окружение в момент запуска.
