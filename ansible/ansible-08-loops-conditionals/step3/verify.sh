#!/bin/bash
if [ ! -f /root/ansible_when_skip.txt ]; then
  echo "Файл /root/ansible_when_skip.txt не найден."
  exit 1
fi

grep -q '^absent$' /root/ansible_when_skip.txt || exit 1
exit 0
