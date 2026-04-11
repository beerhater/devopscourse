#!/bin/bash
if [ ! -f /root/restart_policy_matrix.txt ]; then
  echo "Файл /root/restart_policy_matrix.txt не найден."
  exit 1
fi

grep -q '^restart-demo on-failure 3$' /root/restart_policy_matrix.txt || exit 1
grep -q '^restart-unless unless-stopped$' /root/restart_policy_matrix.txt || exit 1
grep -q '^restart-always always$' /root/restart_policy_matrix.txt || exit 1
exit 0
