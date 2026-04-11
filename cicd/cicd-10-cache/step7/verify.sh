#!/bin/bash
if [ ! -f /root/cicd_cache_checklist.txt ]; then
  echo "Файл /root/cicd_cache_checklist.txt не найден."
  exit 1
fi

grep -q '^stable_cache_key=yes$' /root/cicd_cache_checklist.txt || exit 1
exit 0
