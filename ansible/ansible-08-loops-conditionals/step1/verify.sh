#!/bin/bash
if [ ! -f /root/ansible_loop_result.txt ] || [ ! -f /root/ansible_loop_files.txt ]; then
  echo "Нужны файлы ansible_loop_result.txt и ansible_loop_files.txt."
  exit 1
fi

grep -q '^prod deployment$' /root/ansible_loop_result.txt || exit 1
grep -q '/tmp/api.txt' /root/ansible_loop_files.txt || exit 1
grep -q '/tmp/worker.txt' /root/ansible_loop_files.txt || exit 1
grep -q '/tmp/cron.txt' /root/ansible_loop_files.txt || exit 1
exit 0
