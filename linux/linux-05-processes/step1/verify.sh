#!/bin/bash
if [ -f "/root/processes.txt" ]; then
  exit 0
else
  echo "Файл processes.txt не найден. Попробуйте: ps aux > processes.txt"
  exit 1
fi
