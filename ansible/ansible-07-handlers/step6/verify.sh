#!/bin/bash
if [ ! -f /root/ansible_handler_template.txt ]; then
  echo "Файл /root/ansible_handler_template.txt не найден."
  exit 1
fi

grep -q '^template handler executed$' /root/ansible_handler_template.txt || exit 1
exit 0
