#!/bin/bash
if [ ! -f /root/mixed.log ]; then
  echo "Файл /root/mixed.log не найден."
  exit 1
fi

grep -q "INFO: config loaded" /root/mixed.log || exit 1
grep -q "ERROR: database unreachable" /root/mixed.log || exit 1
exit 0
