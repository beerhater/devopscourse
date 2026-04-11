#!/bin/bash
if [ ! -f /root/ansible_loops_checklist.txt ]; then
  echo "Файл /root/ansible_loops_checklist.txt не найден."
  exit 1
fi

grep -q '^loop_for_repetition=yes$' /root/ansible_loops_checklist.txt || exit 1
exit 0
