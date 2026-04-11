#!/bin/bash
if [ ! -f /root/ansible_resilient_summary.txt ]; then
  echo "Файл /root/ansible_resilient_summary.txt не найден."
  exit 1
fi

grep -q 'rescued' /root/ansible_resilient_summary.txt || exit 1
grep -q 'always' /root/ansible_resilient_summary.txt || exit 1
exit 0
