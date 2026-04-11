#!/bin/bash
if [ ! -f /root/ansible_combined_loop.txt ]; then
  echo "Файл /root/ansible_combined_loop.txt не найден."
  exit 1
fi

grep -q '/tmp/api-combined.txt' /root/ansible_combined_loop.txt || exit 1
grep -q '/tmp/combined-prod-only.txt' /root/ansible_combined_loop.txt || exit 1
exit 0
