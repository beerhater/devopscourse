#!/bin/bash
if [ ! -f /root/config_names.txt ]; then
  echo "Файл /root/config_names.txt не найден."
  exit 1
fi

grep -q "^api.conf$" /root/config_names.txt || exit 1
grep -q "^cron.conf$" /root/config_names.txt || exit 1
grep -q "^worker.conf$" /root/config_names.txt || exit 1
exit 0
