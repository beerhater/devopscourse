#!/bin/bash
if [ ! -f /root/restart_unless_policy.txt ]; then
  echo "Файл /root/restart_unless_policy.txt не найден."
  exit 1
fi

grep -q '^unless-stopped$' /root/restart_unless_policy.txt || exit 1
exit 0
