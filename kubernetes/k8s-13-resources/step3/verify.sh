#!/bin/bash
if [ ! -f /root/resource_qos.txt ]; then
  echo "Файл /root/resource_qos.txt не найден."
  exit 1
fi

grep -q '^Burstable$' /root/resource_qos.txt || exit 1
exit 0
