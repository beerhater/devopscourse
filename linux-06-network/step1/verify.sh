#!/bin/bash
if [ -f "/root/ping_result.txt" ]; then
  exit 0
else
  echo "Файл ping_result.txt не найден. Попробуйте: ping -c 4 8.8.8.8 > ping_result.txt"
  exit 1
fi
