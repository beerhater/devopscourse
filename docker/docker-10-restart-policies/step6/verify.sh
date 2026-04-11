#!/bin/bash
if [ ! -f /root/restart_demo_logs_detailed.txt ]; then
  echo "Файл /root/restart_demo_logs_detailed.txt не найден."
  exit 1
fi

grep -q 'crash-demo' /root/restart_demo_logs_detailed.txt || exit 1
exit 0
