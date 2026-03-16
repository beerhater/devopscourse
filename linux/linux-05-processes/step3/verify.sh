#!/bin/bash
if pgrep -x "sleep" > /dev/null; then
  exit 0
else
  echo "Процесс sleep не найден в фоне. Попробуйте: sleep 1000 &"
  exit 1
fi
