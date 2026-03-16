#!/bin/bash
if [ -f "/root/top_snapshot.txt" ]; then
  exit 0
else
  echo "Файл top_snapshot.txt не найден. Попробуйте: top -bn1 > top_snapshot.txt"
  exit 1
fi
