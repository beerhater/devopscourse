#!/bin/bash
if [ -f "/root/archive/backup.txt" ]; then
  exit 0
else
  echo "Файл backup.txt не найден в папке archive. Попробуйте: mv backup.txt archive/backup.txt"
  exit 1
fi
