## Head, tail и less

Начнём с лаборатории. Создадим набор логов и конфигов, с которыми будем работать весь урок.

```bash
mkdir -p /opt/search-lab/logs /opt/search-lab/configs/api /opt/search-lab/configs/archive /opt/search-lab/services/api/archive /opt/search-lab/services/worker

cat > /opt/search-lab/logs/app.log <<'EOF'
2026-03-20 09:00:01 INFO Boot sequence started
2026-03-20 09:00:05 INFO Loaded config from /etc/devops/app.yml
2026-03-20 09:00:10 WARN Cache warmup is slow
2026-03-20 09:00:15 INFO Connected to redis
2026-03-20 09:00:20 ERROR Failed to reach payment API
2026-03-20 09:00:25 INFO Retrying request
2026-03-20 09:00:30 error Timeout while waiting for response
2026-03-20 09:00:35 INFO Retry succeeded
2026-03-20 09:00:40 WARN disk usage at 75%
2026-03-20 09:00:45 INFO Worker started
2026-03-20 09:00:50 ERROR Queue depth is too high
2026-03-20 09:00:55 INFO Healthcheck passed
EOF

cat > /opt/search-lab/configs/app.env <<'EOF'
APP_ENV=production
DB_HOST=db.internal
DB_PORT=5432
EOF

cat > /opt/search-lab/configs/api/config.yml <<'EOF'
service:
  name: api
  DB_HOST: db.internal
  listen: 8080
EOF

cat > /opt/search-lab/configs/api/app.conf <<'EOF'
worker_processes auto;
EOF

cat > /opt/search-lab/configs/archive/legacy.conf <<'EOF'
legacy_mode=true
EOF

cat > /opt/search-lab/services/api/current.log <<'EOF'
INFO api boot
INFO opening database connection
ERROR Connection refused to db.internal
INFO api retry scheduled
EOF

cat > /opt/search-lab/services/api/archive/error.log <<'EOF'
ERROR Old deployment failed healthcheck
EOF

cat > /opt/search-lab/services/worker/current.log <<'EOF'
INFO worker boot
WARN queue delay is growing
INFO worker still alive
EOF

cat > /opt/search-lab/ip-list.txt <<'EOF'
10.0.0.5
10.0.0.7
10.0.0.5
10.0.0.8
10.0.0.5
10.0.0.7
10.0.0.9
10.0.0.8
EOF
```{{execute}}

Теперь быстро смотрим начало и конец большого файла:

```bash
head -n 3 /opt/search-lab/logs/app.log > /root/app_head.txt
tail -n 3 /opt/search-lab/logs/app.log > /root/app_tail.txt
cat /root/app_head.txt
cat /root/app_tail.txt
```{{execute}}

Для интерактивного просмотра используйте:
`less /opt/search-lab/logs/app.log`

Внутри `less` полезно:
- `/ERROR` — поиск строки;
- `n` — следующее совпадение;
- `q` — выход.

Именно так обычно начинают разбор длинного лога на сервере.
