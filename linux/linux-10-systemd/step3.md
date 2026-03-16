## Автозапуск сервисов (enable / disable)

Команды `start/stop` управляют сервисом **прямо сейчас**.
Но после перезагрузки сервера всё сбросится.

Чтобы сервис запускался **автоматически при каждом старте сервера**:
- `systemctl enable имя` — включить автозапуск
- `systemctl disable имя` — выключить автозапуск

Под капотом `enable` создаёт символическую ссылку в `/etc/systemd/system/`.
Именно по этим ссылкам systemd понимает что запускать при старте.

---

**Шаг 1.** Включите автозапуск nginx:
`systemctl enable nginx`

**Шаг 2.** Проверьте что автозапуск включён:
`systemctl is-enabled nginx`

Должно вернуть: `enabled`

**Шаг 3.** Посмотрите что именно создала команда enable:
`ls -la /etc/systemd/system/multi-user.target.wants/ | grep nginx`

Вы увидите символическую ссылку на unit-файл nginx.

**Шаг 4.** Отключите автозапуск:
`systemctl disable nginx`

**Шаг 5.** Проверьте:
`systemctl is-enabled nginx`

Вернёт: `disabled`

**Шаг 6.** Включите снова (нам понадобится в следующих шагах):
`systemctl enable nginx`
