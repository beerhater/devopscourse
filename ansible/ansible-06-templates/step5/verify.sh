#!/bin/bash
if [ ! -f /root/ansible_template_nested.txt ]; then
  echo "Файл /root/ansible_template_nested.txt не найден."
  exit 1
fi

grep -q '^APP_NAME=billing-api$' /root/ansible_template_nested.txt || exit 1
grep -q '^APP_PORT=9090$' /root/ansible_template_nested.txt || exit 1
exit 0
