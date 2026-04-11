#!/bin/bash
if [ ! -f /root/restart_none_policy.txt ]; then
  echo "Файл /root/restart_none_policy.txt не найден."
  exit 1
fi

grep -q '^ 0$' /root/restart_none_policy.txt || grep -q '^no 0$' /root/restart_none_policy.txt || grep -q '^none 0$' /root/restart_none_policy.txt || exit 1
exit 0
