## Создаём первый tar-архив

`tar` очень часто используют для backup-конфигов, логов и release-артефактов.

Сначала подготовим небольшой учебный проект и упакуем его в архив.

```bash
mkdir -p /opt/archive-lab/project/{config,logs,scripts}

cat > /opt/archive-lab/project/config/app.env <<'EOF'
APP_NAME=platform-api
APP_ENV=staging
APP_PORT=8080
EOF

cat > /opt/archive-lab/project/logs/app.log <<'EOF'
2026-04-10 10:00:01 INFO app started
2026-04-10 10:00:05 WARN cache miss
2026-04-10 10:00:12 ERROR db timeout
EOF

cat > /opt/archive-lab/project/scripts/deploy.sh <<'EOF'
#!/bin/bash
echo "Deploying platform-api"
EOF

chmod +x /opt/archive-lab/project/scripts/deploy.sh

tar -cf /root/project.tar -C /opt/archive-lab project
tar -tf /root/project.tar
```{{execute}}

Что здесь важно:

- `-c` означает создать архив;
- `-f` означает записать архив в файл;
- `-C /opt/archive-lab` говорит tar перейти в каталог перед упаковкой.

Такой подход помогает не тащить в архив длинные абсолютные пути.
