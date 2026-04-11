#!/bin/bash
if [ ! -f /root/restart_policy.txt ] || [ ! -f /root/restart_status.txt ] || [ ! -f /root/restart_logs.txt ]; then
  echo "Нужны файлы restart_policy.txt, restart_status.txt и restart_logs.txt."
  exit 1
fi

grep -q '^on-failure 3$' /root/restart_policy.txt || exit 1
grep -q 'restart-demo' /root/restart_status.txt || exit 1
grep -q 'crash-demo' /root/restart_logs.txt || exit 1
exit 0
