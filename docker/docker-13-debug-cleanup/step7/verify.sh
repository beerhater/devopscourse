#!/bin/bash
if [ ! -f /root/docker_cleanup_checklist.txt ]; then
  echo "Файл /root/docker_cleanup_checklist.txt не найден."
  exit 1
fi

grep -q '^1_inspect_usage=docker_system_df$' /root/docker_cleanup_checklist.txt || exit 1
grep -q '^4_remove_unused_volumes=yes$' /root/docker_cleanup_checklist.txt || exit 1
exit 0
