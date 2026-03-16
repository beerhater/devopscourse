## Переменные и кавычки

**Главное правило:** вокруг `=` не должно быть пробелов!
- Правильно: `NAME="Alice"`
- Ошибка: `NAME = "Alice"`

В двойных кавычках переменные раскрываются, в одинарных — нет.

**Задание:**

`cat << 'SCRIPT' > vars.sh`

`#!/bin/bash`

`USER="Admin"`

`echo "Двойные: Hello $USER"`

`echo 'Одинарные: Hello $USER'`

`SCRIPT`

`chmod +x vars.sh && ./vars.sh`
