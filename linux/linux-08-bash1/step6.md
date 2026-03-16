## Условия if/else (Файлы)

Полезные флаги проверок:
- `-d` — существует ли папка
- `-f` — существует ли файл

**Задание:**

Создайте файл `check_file.sh`:

`cat << 'SCRIPT' > check_file.sh`

`#!/bin/bash`

`DIR="logs"`

`if [ -d "$DIR" ]; then`

`    echo "Уже существует."`

`else`

`    echo "Создаю..."`

`    mkdir $DIR`

`fi`

`SCRIPT`

`chmod +x check_file.sh`

Запустите дважды:

`./check_file.sh`

`./check_file.sh`
