#!/bin/bash
if [ ! -f /root/ansible_template_result.txt ]; then
  echo "Файл /root/ansible_template_result.txt не найден."
  exit 1
fi

grep -q '^APP_NAME=payments-api$' /root/ansible_template_result.txt || exit 1
grep -q '^APP_ENV=prod$' /root/ansible_template_result.txt || exit 1
grep -q '^APP_PORT=8080$' /root/ansible_template_result.txt || exit 1
exit 0
