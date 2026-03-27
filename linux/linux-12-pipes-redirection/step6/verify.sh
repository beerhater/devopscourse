#!/bin/bash
if [ ! -f /root/recent_errors.txt ]; then
  echo "Файл /root/recent_errors.txt не найден."
  exit 1
fi

grep -q "ERROR database timeout" /root/recent_errors.txt || exit 1
grep -qi "error queue overflow" /root/recent_errors.txt || exit 1
exit 0
