#!/bin/bash
if [ ! -f /root/ansible_handler_multi.txt ]; then
  echo "Файл /root/ansible_handler_multi.txt не найден."
  exit 1
fi

grep -q '^multi handler executed$' /root/ansible_handler_multi.txt || exit 1
exit 0
