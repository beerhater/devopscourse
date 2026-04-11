#!/bin/bash
if [ ! -f /root/ansible_template_conditional.txt ]; then
  echo "Файл /root/ansible_template_conditional.txt не найден."
  exit 1
fi

grep -q '^FEATURE_METRICS=enabled$' /root/ansible_template_conditional.txt || exit 1
exit 0
