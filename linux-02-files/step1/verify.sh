#!/bin/bash
if [ -f "/root/hello.txt" ]; then
  content=$(cat /root/hello.txt)
  if [ "$content" = "Hello DevOps" ]; then
    exit 0
  else
    echo "Файл hello.txt существует, но содержимое неверное. Попробуйте: echo \"Hello DevOps\" > hello.txt"
    exit 1
  fi
else
  echo "Файл hello.txt не найден. Попробуйте: echo \"Hello DevOps\" > hello.txt"
  exit 1
fi
