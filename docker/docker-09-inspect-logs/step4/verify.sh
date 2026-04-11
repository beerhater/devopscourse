#!/bin/bash
if [ ! -f /root/inspect_inside.txt ]; then
  echo "Файл /root/inspect_inside.txt не найден."
  exit 1
fi

grep -q 'nginx.conf' /root/inspect_inside.txt || exit 1
grep -q 'worker_processes' /root/inspect_inside.txt || exit 1
exit 0
