#!/bin/bash
if [ -f "/root/myfile.txt" ]; then
  exit 0
else
  echo "Файл myfile.txt не найден. Попробуйте: touch myfile.txt"
  exit 1
fi
