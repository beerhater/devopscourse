#!/bin/bash
if [ ! -f /root/ansible_services_list.txt ]; then
  echo "Файл /root/ansible_services_list.txt не найден."
  exit 1
fi

grep -q '^api$' /root/ansible_services_list.txt || exit 1
grep -q '^cron$' /root/ansible_services_list.txt || exit 1
exit 0
