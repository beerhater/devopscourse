## Урок 10 пройден!

Вы освоили один из самых важных инструментов Linux-администратора.

Шпаргалка по systemd:

**Управление сервисами:**
- `systemctl start/stop/restart/reload имя`
- `systemctl status имя`
- `systemctl enable/disable имя`
- `systemctl daemon-reload` — после изменения unit-файлов

**Логи и диагностика:**
- `journalctl -u имя -f` — следить в реальном времени
- `journalctl -u имя -n 100` — последние 100 строк
- `journalctl -u имя -p err` — только ошибки
- `journalctl -u имя --since "1 hour ago"` — за последний час
- `journalctl -u имя -p err --since "10 minutes ago"` — быстро собрать свежие ошибки сервиса

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

Впереди ещё два практических Linux-урока:
поиск и фильтрация данных, а затем pipes и перенаправление вывода.
После них Linux-блок станет полноценной базой перед Docker и CI/CD.
