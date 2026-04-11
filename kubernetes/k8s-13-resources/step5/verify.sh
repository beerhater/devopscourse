#!/bin/bash
if [ ! -f /root/qos_compare.txt ]; then
  echo "Файл /root/qos_compare.txt не найден."
  exit 1
fi

grep -q '^resource-demo Burstable$' /root/qos_compare.txt || exit 1
grep -q '^guaranteed-demo Guaranteed$' /root/qos_compare.txt || exit 1
exit 0
