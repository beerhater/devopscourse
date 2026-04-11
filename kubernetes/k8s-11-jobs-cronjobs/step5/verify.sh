#!/bin/bash
if [ ! -f /root/cronjob_resumed.txt ]; then
  echo "Файл /root/cronjob_resumed.txt не найден."
  exit 1
fi

grep -q '^false$' /root/cronjob_resumed.txt || exit 1
exit 0
