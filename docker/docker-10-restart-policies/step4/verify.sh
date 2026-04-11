#!/bin/bash
if [ ! -f /root/restart_always_policy.txt ]; then
  echo "Файл /root/restart_always_policy.txt не найден."
  exit 1
fi

grep -q '^always$' /root/restart_always_policy.txt || exit 1
exit 0
