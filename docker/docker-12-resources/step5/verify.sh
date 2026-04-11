#!/bin/bash
if [ ! -f /root/resource_stats.txt ]; then
  echo "Файл /root/resource_stats.txt не найден."
  exit 1
fi

grep -q '^resource-demo ' /root/resource_stats.txt || exit 1
exit 0
