#!/bin/bash
if [ ! -f /root/ansible_handlers_checklist.txt ]; then
  echo "Файл /root/ansible_handlers_checklist.txt не найден."
  exit 1
fi

grep -q '^handler_runs_once=yes$' /root/ansible_handlers_checklist.txt || exit 1
exit 0
