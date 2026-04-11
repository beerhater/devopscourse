#!/bin/bash
if [ ! -f /root/resource_final_limits.txt ]; then
  echo "Файл /root/resource_final_limits.txt не найден."
  exit 1
fi

grep -q 'memory=134217728' /root/resource_final_limits.txt || exit 1
grep -q '^pids=50$' /root/resource_final_limits.txt || exit 1
grep -q 'nofile=' /root/resource_final_limits.txt || exit 1
exit 0
