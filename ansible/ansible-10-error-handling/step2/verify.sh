#!/bin/bash
if [ ! -f /root/ansible_failed_when.txt ]; then
  echo "Файл /root/ansible_failed_when.txt не найден."
  exit 1
fi

grep -q 'failed_when_result' /root/ansible_failed_when.txt || grep -q 'fatal:' /root/ansible_failed_when.txt || exit 1
exit 0
