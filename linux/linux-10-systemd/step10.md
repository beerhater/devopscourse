## Практика — ищем почему сервис не стартует

Реальная работа DevOps-инженера редко ограничивается `systemctl start`.
Чаще задача звучит так: "сервис не поднялся, найди почему".

Сейчас специально создадим сломанный сервис, посмотрим его статус,
прочитаем ошибки через `journalctl`, а потом исправим проблему.

**Шаг 1.** Создайте unit-файл со ссылкой на несуществующий скрипт:
```bash
cat > /etc/systemd/system/broken-demo.service <<'EOF'
[Unit]
Description=Broken Demo Service
After=network.target

[Service]
Type=simple
ExecStart=/usr/local/bin/broken-demo.sh
Restart=no

[Install]
WantedBy=multi-user.target
EOF
```

**Шаг 2.** Перечитайте конфиг systemd и попробуйте запустить сервис:
```bash
systemctl daemon-reload
systemctl start broken-demo || true
```

**Шаг 3.** Посмотрите статус:
`systemctl status broken-demo`

**Шаг 4.** Найдите ошибку в логах конкретного сервиса:
`journalctl -u broken-demo -n 20`

**Шаг 5.** Отфильтруйте только ошибки за последние 10 минут и сохраните их:
`journalctl -u broken-demo -p err --since "10 minutes ago" > /root/broken-demo-errors.log`

Ищите что-то вроде `No such file or directory` или `Failed at step EXEC`.

**Шаг 6.** Исправьте проблему — создайте скрипт, которого не хватало:
```bash
cat > /usr/local/bin/broken-demo.sh <<'EOF'
#!/bin/bash
while true; do
  echo "broken-demo is healthy"
  sleep 30
done
EOF
```

**Шаг 7.** Сделайте скрипт исполняемым и заново запустите сервис:
```bash
chmod +x /usr/local/bin/broken-demo.sh
systemctl start broken-demo
```

**Шаг 8.** Проверьте что сервис поднялся:
`systemctl is-active broken-demo`

Это и есть типичный цикл диагностики:
`status` → `journalctl -u` → `journalctl -p err --since` → исправление → повторный старт.
