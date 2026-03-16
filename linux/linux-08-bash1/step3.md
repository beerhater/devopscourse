## Переменные из команд

Чтобы сохранить результат команды используйте `$(команда)`.

**Задание:**

Создайте файл `cmd.sh`:

`cat << 'SCRIPT' > cmd.sh`

`#!/bin/bash`

`CURRENT_DATE=$(date)`

`FILE_COUNT=$(ls | wc -l)`

`echo "Сегодня: $CURRENT_DATE, файлов: $FILE_COUNT"`

`SCRIPT`

`chmod +x cmd.sh && ./cmd.sh`
