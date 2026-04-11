#!/bin/bash
if [ ! -f /root/cicd_vars_checklist.txt ]; then
  echo "Файл /root/cicd_vars_checklist.txt не найден."
  exit 1
fi

grep -q '^no_hardcoded_passwords=yes$' /root/cicd_vars_checklist.txt || exit 1
exit 0
