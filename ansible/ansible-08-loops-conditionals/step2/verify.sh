#!/bin/bash
if [ ! -f /root/ansible_loop_dicts.txt ]; then
  echo "Файл /root/ansible_loop_dicts.txt не найден."
  exit 1
fi

grep -q '/tmp/api-8080.txt' /root/ansible_loop_dicts.txt || exit 1
grep -q '/tmp/worker-9000.txt' /root/ansible_loop_dicts.txt || exit 1
exit 0
