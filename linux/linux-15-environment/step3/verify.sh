#!/bin/bash
if [ ! -f /root/runtime_summary.txt ]; then
  echo "Файл /root/runtime_summary.txt не найден."
  exit 1
fi

grep -q "^APP_NAME=platform-api$" /root/runtime_summary.txt || exit 1
grep -q "^APP_ENV=staging$" /root/runtime_summary.txt || exit 1
grep -q "^APP_PORT=8080$" /root/runtime_summary.txt || exit 1
exit 0
