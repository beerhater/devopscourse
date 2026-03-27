#!/bin/bash
if [ ! -f /root/services_count.txt ] || [ ! -f /root/services_sorted.txt ]; then
  echo "Нужны файлы /root/services_count.txt и /root/services_sorted.txt."
  exit 1
fi

count=$(tr -d '[:space:]' < /root/services_count.txt)
if [ "$count" != "5" ]; then
  echo "Ожидалось 5 сервисов, сейчас: $count"
  exit 1
fi

first=$(head -n 1 /root/services_sorted.txt)
if [ "$first" = "docker" ]; then
  exit 0
else
  echo "Ожидалось что первым после sort будет docker, сейчас: $first"
  exit 1
fi
