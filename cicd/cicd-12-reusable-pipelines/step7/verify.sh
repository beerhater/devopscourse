#!/bin/bash
if [ ! -f /root/reusable_checklist.txt ]; then
  echo "Файл /root/reusable_checklist.txt не найден."
  exit 1
fi

grep -q '^avoid_copy_paste=yes$' /root/reusable_checklist.txt || exit 1
grep -q '^inherit_secrets_carefully=yes$' /root/reusable_checklist.txt || exit 1
exit 0
