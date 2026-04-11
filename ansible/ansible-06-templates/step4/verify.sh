#!/bin/bash
if [ ! -f /root/ansible_template_default.txt ]; then
  echo "Файл /root/ansible_template_default.txt не найден."
  exit 1
fi

grep -q '^LOG_LEVEL=info$' /root/ansible_template_default.txt || exit 1
exit 0
