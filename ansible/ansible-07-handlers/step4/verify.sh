#!/bin/bash
if [ ! -f /root/ansible_handler_listen.txt ]; then
  echo "Файл /root/ansible_handler_listen.txt не найден."
  exit 1
fi

grep -q '^listen handler executed$' /root/ansible_handler_listen.txt || exit 1
exit 0
