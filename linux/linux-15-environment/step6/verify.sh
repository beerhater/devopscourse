#!/bin/bash
if [ ! -f /root/release_file_summary.txt ]; then
  echo "Файл /root/release_file_summary.txt не найден."
  exit 1
fi

grep -q "^APP_NAME=payments-api$" /root/release_file_summary.txt || exit 1
grep -q "^APP_ENV=prod$" /root/release_file_summary.txt || exit 1
grep -q "^APP_PORT=9090$" /root/release_file_summary.txt || exit 1
exit 0
