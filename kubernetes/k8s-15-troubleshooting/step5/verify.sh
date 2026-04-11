#!/bin/bash
if [ ! -f /root/crash_logs.txt ]; then
  echo "Файл /root/crash_logs.txt не найден."
  exit 1
fi

grep -q 'crash-loop' /root/crash_logs.txt || exit 1
exit 0
