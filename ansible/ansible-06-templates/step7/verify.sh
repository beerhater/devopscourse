#!/bin/bash
if [ ! -f /root/ansible_template_checklist.txt ]; then
  echo "Файл /root/ansible_template_checklist.txt не найден."
  exit 1
fi

grep -q '^loops_in_templates=yes$' /root/ansible_template_checklist.txt || exit 1
exit 0
