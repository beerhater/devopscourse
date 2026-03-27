#!/bin/bash
if [ ! -f /root/status_summary.txt ]; then
  echo "Файл /root/status_summary.txt не найден."
  exit 1
fi

grep -Eq "^[[:space:]]*3 200$" /root/status_summary.txt || exit 1
grep -Eq "^[[:space:]]*2 500$" /root/status_summary.txt || exit 1
exit 0
