#!/bin/bash
if [ ! -f /root/ansible_handler_result.txt ]; then
  echo "Файл /root/ansible_handler_result.txt не найден."
  exit 1
fi

grep -q '^handler executed$' /root/ansible_handler_result.txt || exit 1
exit 0
