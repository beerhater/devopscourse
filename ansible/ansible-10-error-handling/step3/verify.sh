#!/bin/bash
if [ ! -f /root/ansible_ignore_errors.txt ]; then
  echo "Файл /root/ansible_ignore_errors.txt не найден."
  exit 1
fi

grep -q '^continued after error$' /root/ansible_ignore_errors.txt || exit 1
exit 0
