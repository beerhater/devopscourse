#!/bin/bash
if [ ! -f /root/ansible_tags_result.txt ] || [ ! -f /root/ansible_tags_deploy.txt ]; then
  echo "Нужны файлы ansible_tags_result.txt и ansible_tags_deploy.txt."
  exit 1
fi

grep -q '^config updated$' /root/ansible_tags_result.txt || exit 1
grep -q '^absent$' /root/ansible_tags_deploy.txt || exit 1
exit 0
