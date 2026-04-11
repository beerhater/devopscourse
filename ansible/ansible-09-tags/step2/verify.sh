#!/bin/bash
if [ ! -f /root/ansible_list_tags.txt ]; then
  echo "Файл /root/ansible_list_tags.txt не найден."
  exit 1
fi

grep -q 'TASK TAGS' /root/ansible_list_tags.txt || exit 1
grep -q 'config' /root/ansible_list_tags.txt || exit 1
grep -q 'deploy' /root/ansible_list_tags.txt || exit 1
exit 0
