#!/bin/bash
if [ ! -f /root/hosts_normalized.txt ]; then
  echo "Файл /root/hosts_normalized.txt не найден."
  exit 1
fi

grep -q "^web-01$" /root/hosts_normalized.txt || exit 1
grep -q "^api-01$" /root/hosts_normalized.txt || exit 1
grep -q "^db-01$" /root/hosts_normalized.txt || exit 1
exit 0
