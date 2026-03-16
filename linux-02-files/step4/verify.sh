#!/bin/bash
if [ ! -f "/root/hello.txt" ]; then
  exit 0
else
  echo "Файл hello.txt всё ещё существует. Удалите его: rm hello.txt"
  exit 1
fi
