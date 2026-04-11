#!/bin/bash
if [ ! -f /root/ansible_handler_flush.txt ]; then
  echo "Файл /root/ansible_handler_flush.txt не найден."
  exit 1
fi

grep -q '^present$' /root/ansible_handler_flush.txt || exit 1
exit 0
