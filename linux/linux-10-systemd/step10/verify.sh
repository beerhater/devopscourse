#!/bin/bash
if [ ! -f "/root/broken-demo-errors.log" ]; then
  echo "Файл /root/broken-demo-errors.log не найден. Сохраните ошибки через journalctl."
  exit 1
fi

if ! grep -Eq "No such file|Failed at step EXEC|broken-demo" /root/broken-demo-errors.log; then
  echo "В /root/broken-demo-errors.log не видно диагностического вывода broken-demo."
  exit 1
fi

if systemctl is-active broken-demo >/dev/null 2>&1; then
  exit 0
else
  echo "Сервис broken-demo не active. Проверьте unit, скрипт и повторный запуск."
  exit 1
fi
