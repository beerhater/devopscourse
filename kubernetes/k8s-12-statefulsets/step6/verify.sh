#!/bin/bash
if [ ! -f /root/stateful_restart_ready.txt ]; then
  echo "Файл /root/stateful_restart_ready.txt не найден."
  exit 1
fi

grep -q '^2$' /root/stateful_restart_ready.txt || exit 1
exit 0
