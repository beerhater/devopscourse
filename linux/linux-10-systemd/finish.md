## Урок 10 пройден! Блок Linux завершён!

Вы освоили один из самых важных инструментов Linux-администратора.

Шпаргалка по systemd:

**Управление сервисами:**
- `systemctl start/stop/restart/reload имя`
- `systemctl status имя`
- `systemctl enable/disable имя`
- `systemctl daemon-reload` — после изменения unit-файлов

**Логи:**
- `journalctl -u имя -f` — следить в реальном времени
- `journalctl -u имя -n 100` — последние 100 строк
- `journalctl -u имя -p err` — только ошибки
- `journalctl -u имя --since "1 hour ago"` — за последний час

**Свой сервис** — минимальный unit-файл:
```
[Unit]
Description=My App
After=network.target

[Service]
ExecStart=/path/to/app
Restart=on-failure

[Install]
WantedBy=multi-user.target
```

---

Поздравляем! Блок Linux полностью завершён.
Следующий блок — Docker. Вы научитесь упаковывать
приложения в контейнеры и запускать их на любом сервере.
