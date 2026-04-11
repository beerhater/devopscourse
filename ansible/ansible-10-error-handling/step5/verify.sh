#!/bin/bash
if [ ! -f /root/ansible_changed_when.txt ]; then
  echo "Файл /root/ansible_changed_when.txt не найден."
  exit 1
fi

grep -q 'changed=0' /root/ansible_changed_when.txt || exit 1
exit 0
