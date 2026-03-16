#!/bin/bash
# Проверяем что студент взаимодействовал с jobs — sleep всё ещё работает в фоне
if pgrep -x "sleep" > /dev/null; then
  exit 0
else
  echo "Запустите sleep в фоне: sleep 1000 & затем поработайте с fg/bg"
  exit 1
fi
