## Загружаем переменные из env-файла

Теперь соберём более реалистичный сценарий: есть env-файл, и нужно быстро загрузить его в окружение перед запуском скрипта.

```bash
cat > /root/release.env <<'EOF'
APP_NAME=payments-api
APP_ENV=prod
APP_PORT=9090
EOF

set -a
source /root/release.env
set +a

/opt/env-lab/bin/release-summary.sh > /root/release_file_summary.txt
cat /root/release_file_summary.txt
```{{execute}}

`set -a` автоматически экспортирует переменные, которые появляются после `source`.

Это очень практичный паттерн для локальных запусков и быстрой проверки `.env`-подобных файлов.
