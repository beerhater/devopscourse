#!/bin/bash
if [ ! -f /root/ansible_template_loop.txt ]; then
  echo "Файл /root/ansible_template_loop.txt не найден."
  exit 1
fi

grep -q '^server api-1.internal;$' /root/ansible_template_loop.txt || exit 1
grep -q '^server api-2.internal;$' /root/ansible_template_loop.txt || exit 1
exit 0
