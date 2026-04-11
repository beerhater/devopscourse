#!/bin/bash
if [ ! -f /root/resource_pids_limit.txt ]; then
  echo "Файл /root/resource_pids_limit.txt не найден."
  exit 1
fi

grep -q '^50$' /root/resource_pids_limit.txt || exit 1
exit 0
