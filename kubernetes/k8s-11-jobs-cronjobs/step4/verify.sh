#!/bin/bash
if [ ! -f /root/cronjob_suspended.txt ]; then
  echo "Файл /root/cronjob_suspended.txt не найден."
  exit 1
fi

grep -q '^true$' /root/cronjob_suspended.txt || exit 1
exit 0
