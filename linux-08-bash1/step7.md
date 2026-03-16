## Базовый цикл for

Синтаксис:

`for ПЕРЕМЕННАЯ in СПИСОК; do`

`    команды`

`done`

**Задание:**

`cat << 'SCRIPT' > loop.sh`

`#!/bin/bash`

`for SERVER in web1 web2 db1; do`

`    echo "Подключение к $SERVER..."`

`done`

`SCRIPT`

`chmod +x loop.sh && ./loop.sh`
