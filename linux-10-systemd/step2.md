## Основные команды systemctl

`systemctl` — главная команда для управления сервисами.

Вот полный список команд которые вы будете использовать каждый день:

```
systemctl start имя      — запустить сервис
systemctl stop имя       — остановить сервис
systemctl restart имя    — перезапустить (stop + start)
systemctl reload имя     — перечитать конфиг БЕЗ остановки
systemctl status имя     — подробный статус сервиса
systemctl is-active имя  — работает ли? (active/inactive)
systemctl is-enabled имя — включён ли автозапуск?
```

---

Установим nginx и попрактикуемся на нём:

**Шаг 1.** Установите nginx:
`apt-get install -y nginx`

**Шаг 2.** Запустите сервис:
`systemctl start nginx`

**Шаг 3.** Проверьте статус — найдите строку `Active: active (running)`:
`systemctl status nginx`

**Шаг 4.** Остановите сервис:
`systemctl stop nginx`

**Шаг 5.** Убедитесь что остановился — должно быть `inactive (dead)`:
`systemctl status nginx`

**Шаг 6.** Снова запустите:
`systemctl start nginx`
