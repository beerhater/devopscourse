## Условия if/else (Числа)

Внутри `[ ]` обязательны пробелы по краям!

Операторы: `-eq` (равно), `-ne` (не равно), `-gt` (больше), `-lt` (меньше), `-ge` (больше или равно).

**Задание:**

Создайте файл `check_num.sh`:

`cat << 'SCRIPT' > check_num.sh`

`#!/bin/bash`

`AGE=25`

`if [ $AGE -ge 18 ]; then`

`    echo "Доступ разрешен"`

`else`

`    echo "Доступ запрещен"`

`fi`

`SCRIPT`

`chmod +x check_num.sh && ./check_num.sh`
