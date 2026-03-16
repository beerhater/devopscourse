## Анатомия unit-файла

Каждый сервис в systemd описывается **unit-файлом** с расширением `.service`.
Все системные unit-файлы лежат в `/lib/systemd/system/`.
Ваши собственные — в `/etc/systemd/system/`.

Посмотрим как устроен unit-файл nginx:
`cat /lib/systemd/system/nginx.service`

Unit-файл состоит из трёх секций:

**[Unit]** — метаданные и зависимости:
```
Description=   — человекочитаемое описание
After=         — запускаться ПОСЛЕ каких сервисов
Requires=      — жёсткая зависимость (упал тот — упаём мы)
Wants=         — мягкая зависимость (упал тот — нам всё равно)
```

**[Service]** — как запускать:
```
Type=          — simple/forking/oneshot/notify
ExecStart=     — команда запуска
ExecStop=      — команда остановки
ExecReload=    — команда перезагрузки конфига
Restart=       — когда перезапускать (always/on-failure/no)
RestartSec=    — пауза перед рестартом
User=          — от какого пользователя запускать
WorkingDirectory= — рабочая директория
```

**[Install]** — при каком target включать автозапуск:
```
WantedBy=multi-user.target  — стандарт для большинства сервисов
```

---

**Задание:**
Изучите unit-файл nginx и ответьте себе на вопросы:

`cat /lib/systemd/system/nginx.service`

**Шаг 1.** Посмотрите файл:
`cat /lib/systemd/system/nginx.service`

**Шаг 2.** Сохраните его для изучения:
`cp /lib/systemd/system/nginx.service /root/nginx.service.example`
