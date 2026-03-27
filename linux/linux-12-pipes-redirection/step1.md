## stdout и stderr простым языком

У большинства команд есть два основных потока:
- `stdout` — обычный полезный вывод;
- `stderr` — ошибки и предупреждения.

Сначала создадим лабораторию и посмотрим это на практике.

```bash
mkdir -p /opt/pipes-lab

cat > /opt/pipes-lab/check_paths.sh <<'EOF'
#!/bin/bash
echo "STDOUT: checking /etc/passwd"
ls /etc/passwd
echo "STDERR: checking /opt/pipes-lab/missing-file" >&2
ls /opt/pipes-lab/missing-file
EOF

cat > /opt/pipes-lab/mixed-output.sh <<'EOF'
#!/bin/bash
echo "INFO: config loaded"
echo "WARN: cache is cold"
echo "ERROR: database unreachable" >&2
EOF

cat > /opt/pipes-lab/services.txt <<'EOF'
nginx
postgresql
redis
docker
sshd
EOF

cat > /opt/pipes-lab/events.log <<'EOF'
INFO bootstrap started
WARN cache cold
ERROR disk almost full
INFO retry scheduled
ERROR database timeout
error queue overflow
EOF

cat > /opt/pipes-lab/statuses.log <<'EOF'
# http statuses from a smoke test
200
500
200
404
503
200
500
EOF
```{{execute}}

Теперь разведём обычный вывод и ошибки по разным файлам:

```bash
bash /opt/pipes-lab/check_paths.sh > /root/stdout.log 2> /root/stderr.log
cat /root/stdout.log
cat /root/stderr.log
```{{execute}}

Это базовый принцип почти всех production-скриптов:
полезный вывод пишем в один поток, ошибки — в другой.
