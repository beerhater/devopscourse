## Функция с аргументами

Функции тоже умеют принимать аргументы — точно так же как и сам скрипт.
Внутри функции `$1` — это первый аргумент переданный **функции**, не скрипту.

```
function greet() {
    echo "Привет, $1!"  # $1 здесь — аргумент функции
}

greet "Alice"   # выведет: Привет, Alice!
greet "Bob"     # выведет: Привет, Bob!
```

---

Напишем реальный пример: функция которая проверяет доступность сервера по IP.

**Шаг 1.** Создайте скрипт:
`nano check_servers.sh`

**Шаг 2.** Введите код:
```
#!/bin/bash

function check_server() {
    SERVER=$1
    echo -n "Проверяю $SERVER... "
    if ping -c 1 -W 1 "$SERVER" &>/dev/null; then
        echo "ДОСТУПЕН"
    else
        echo "НЕДОСТУПЕН"
    fi
}

echo "=== Проверка серверов ==="
check_server "8.8.8.8"
check_server "1.1.1.1"
check_server "192.168.99.99"
```
Сохраните: `Ctrl+O` → Enter → `Ctrl+X`

**Шаг 3.** Запустите:
`chmod +x check_servers.sh && ./check_servers.sh`
