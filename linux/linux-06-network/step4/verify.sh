#!/bin/bash
if [ -f "/root/ports.txt" ]; then
  if grep -q ":80" /root/ports.txt; then
    exit 0
  else
    echo "В файле ports.txt не найден порт 80. Убедитесь что nginx запущен: systemctl start nginx"
    exit 1
  fi
else
  echo "Файл ports.txt не найден. Попробуйте: ss -tulnp > ports.txt"
  exit 1
fi
