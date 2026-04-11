#!/bin/bash
if [ ! -f /root/ansible_error_checklist.txt ]; then
  echo "Файл /root/ansible_error_checklist.txt не найден."
  exit 1
fi

grep -q '^use_rescue_for_controlled_recovery=yes$' /root/ansible_error_checklist.txt || exit 1
exit 0
