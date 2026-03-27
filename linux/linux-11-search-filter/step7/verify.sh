#!/bin/bash
if [ ! -f /root/log_files.txt ] || [ ! -f /root/error_count.txt ]; then
  echo "Нужны файлы /root/log_files.txt и /root/error_count.txt."
  exit 1
fi

grep -q "/opt/search-lab/services/api/current.log" /root/log_files.txt || exit 1
grep -q "/opt/search-lab/services/api/archive/error.log" /root/log_files.txt || exit 1
grep -q "/opt/search-lab/services/worker/current.log" /root/log_files.txt || exit 1

count=$(tr -d '[:space:]' < /root/error_count.txt)
if [ "$count" = "2" ]; then
  exit 0
else
  echo "Ожидалось 2 строки с error, сейчас: $count"
  exit 1
fi
