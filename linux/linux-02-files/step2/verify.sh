#!/bin/bash
if [ -f "/root/backup.txt" ]; then
  exit 0
else
  echo "Файл backup.txt не найден. Попробуйте: cp hello.txt backup.txt"
  exit 1
fi
