#!/bin/bash
if [ ! -f /root/ansible_tags_checklist.txt ]; then
  echo "Файл /root/ansible_tags_checklist.txt не найден."
  exit 1
fi

grep -q '^list_tags_before_targeted_run=yes$' /root/ansible_tags_checklist.txt || exit 1
exit 0
