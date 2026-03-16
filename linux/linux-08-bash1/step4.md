## Математика в Bash

Для математики используйте `$(( выражение ))`.

**Задание:**

Создайте файл `math.sh`:

`cat << 'SCRIPT' > math.sh`

`#!/bin/bash`

`A=10`

`B=5`

`SUM=$((A + B))`

`echo "Сумма: $SUM"`

`SCRIPT`

`chmod +x math.sh && ./math.sh`
