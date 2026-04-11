#!/bin/bash
if [ ! -f /root/ansible_template_prod_env.txt ]; then
  echo "Файл /root/ansible_template_prod_env.txt не найден."
  exit 1
fi

grep -q '^APP_ENV=production$' /root/ansible_template_prod_env.txt || exit 1
grep -q '^LOG_LEVEL=warn$' /root/ansible_template_prod_env.txt || exit 1
exit 0
