## Создаём свой сервис

Теперь создадим полноценный сервис с нуля.
Сначала напишем скрипт который будет "работать" как приложение,
затем обернём его в systemd unit.

---

**Шаг 1.** Создайте скрипт приложения:
`nano /usr/local/bin/myapp.sh`

Введите:
```
#!/bin/bash
while true; do
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] myapp is running..."
    sleep 5
done
```
Сохраните: `Ctrl+O` → Enter → `Ctrl+X`

**Шаг 2.** Сделайте исполняемым:
`chmod +x /usr/local/bin/myapp.sh`

**Шаг 3.** Создайте unit-файл:
`nano /etc/systemd/system/myapp.service`

Введите:
```
[Unit]
Description=My Demo Application
After=network.target

[Service]
Type=simple
ExecStart=/usr/local/bin/myapp.sh
Restart=on-failure
RestartSec=5s
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
```
Сохраните: `Ctrl+O` → Enter → `Ctrl+X`

**Шаг 4.** Сообщите systemd о новом сервисе (обязательно после любых изменений unit-файла!):
`systemctl daemon-reload`

**Шаг 5.** Запустите и включите автозапуск:
`systemctl start myapp`
`systemctl enable myapp`

**Шаг 6.** Проверьте что работает:
`systemctl status myapp`
