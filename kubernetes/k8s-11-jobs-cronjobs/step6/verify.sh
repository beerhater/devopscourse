#!/bin/bash
if [ ! -f /root/cronjob_history_limits.txt ]; then
  echo "Файл /root/cronjob_history_limits.txt не найден."
  exit 1
fi

grep -q '^1 1$' /root/cronjob_history_limits.txt || exit 1
exit 0
