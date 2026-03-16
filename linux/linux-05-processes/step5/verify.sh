#!/bin/bash
# Проверяем что процессов sleep с 1000 и 2000 не осталось
if pgrep -f "sleep 1000" > /dev/null || pgrep -f "sleep 2000" > /dev/null; then
  echo "Процессы sleep 1000 или sleep 2000 ещё работают. Убейте их: kill -9 \$(pgrep sleep)"
  exit 1
else
  exit 0
fi
