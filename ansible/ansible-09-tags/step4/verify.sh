#!/bin/bash
if [ ! -f /root/ansible_multi_tags.txt ] || [ ! -f /root/ansible_multi_tags_deploy.txt ]; then
  echo "Нужны файлы ansible_multi_tags.txt и ansible_multi_tags_deploy.txt."
  exit 1
fi

grep -q '/tmp/tag-config2.txt' /root/ansible_multi_tags.txt || exit 1
grep -q '/tmp/tag-smoke.txt' /root/ansible_multi_tags.txt || exit 1
grep -q '^absent$' /root/ansible_multi_tags_deploy.txt || exit 1
exit 0
