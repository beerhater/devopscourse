## Практика — скрипт бэкапа

Сначала создадим файлы для теста:

`touch app1.log app2.log app3.log`

**Задание:**

`cat << 'SCRIPT' > backup.sh`

`#!/bin/bash`

`for FILE in *.log; do`

`    echo "Копирую $FILE"`

`    cp "$FILE" "$FILE.bak"`

`done`

`ls -l *.bak`

`SCRIPT`

`chmod +x backup.sh && ./backup.sh`
