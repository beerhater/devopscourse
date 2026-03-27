#!/bin/bash
if [ ! -f /root/app_head.txt ] || [ ! -f /root/app_tail.txt ]; then
  echo "Файлы /root/app_head.txt и /root/app_tail.txt должны быть созданы."
  exit 1
fi

grep -q "2026-03-20 09:00:01 INFO Boot sequence started" /root/app_head.txt || exit 1
grep -q "2026-03-20 09:00:55 INFO Healthcheck passed" /root/app_tail.txt || exit 1
exit 0
