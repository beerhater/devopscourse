#!/bin/bash
if [ ! -f /root/ansible_handler_second_run.txt ]; then
  echo "Файл /root/ansible_handler_second_run.txt не найден."
  exit 1
fi

grep -q 'changed=0' /root/ansible_handler_second_run.txt || exit 1
exit 0
