#!/bin/bash
if [ ! -f /root/ansible_block_rescue_summary.txt ]; then
  echo "Файл /root/ansible_block_rescue_summary.txt не найден."
  exit 1
fi

grep -q 'rescue executed' /root/ansible_block_rescue_summary.txt || exit 1
grep -q 'always executed' /root/ansible_block_rescue_summary.txt || exit 1
exit 0
