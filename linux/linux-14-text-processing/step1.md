## Берём нужные колонки через cut

`cut` удобен, когда у вас есть CSV или другой разделённый текст и нужно быстро вытащить только нужные поля.

Подготовим учебные файлы и извлечём имя пользователя и роль:

```bash
mkdir -p /opt/text-lab/configs

cat > /opt/text-lab/users.csv <<'EOF'
name,team,role,shell
anna,platform,devops,/bin/bash
boris,backend,developer,/bin/zsh
irina,platform,sre,/bin/bash
EOF

cat > /opt/text-lab/hosts.raw <<'EOF'
WEB-01,API-01,DB-01,WEB-01
EOF

cat > /opt/text-lab/app.env <<'EOF'
APP_ENV=dev
APP_PORT=3000
LOG_LEVEL=debug
EOF

cat > /opt/text-lab/resources.tsv <<'EOF'
service	cpu_millicores	memory_mb
api	200	256
worker	300	512
cron	100	128
EOF

cat > /opt/text-lab/deployments.csv <<'EOF'
service,env,image
api,prod,nginx:1.27
worker,stage,busybox:1.36
cron,prod,alpine:3.20
EOF

cat > /opt/text-lab/configs/api.conf <<'EOF'
PORT=8080
EOF

cat > /opt/text-lab/configs/worker.conf <<'EOF'
CONCURRENCY=4
EOF

cat > /opt/text-lab/configs/cron.conf <<'EOF'
SCHEDULE=*/5 * * * *
EOF

cut -d, -f1,3 /opt/text-lab/users.csv > /root/user_roles.txt
cat /root/user_roles.txt
```{{execute}}

Здесь:

- `-d,` задаёт разделитель;
- `-f1,3` говорит взять 1 и 3 поля.

Это полезно, когда надо быстро вытащить только значимые колонки из выгрузки.
