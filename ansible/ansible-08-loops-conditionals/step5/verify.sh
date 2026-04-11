#!/bin/bash
if [ ! -f /root/ansible_loop_label.txt ]; then
  echo "Файл /root/ansible_loop_label.txt не найден."
  exit 1
fi

grep -q 'ok: \[localhost\] => (item=api)' /root/ansible_loop_label.txt || exit 1
grep -q 'ok: \[localhost\] => (item=worker)' /root/ansible_loop_label.txt || exit 1
exit 0
