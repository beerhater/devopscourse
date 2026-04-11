#!/bin/bash
if [ ! -f /root/ansible_tags_final.yml ]; then
  echo "Файл /root/ansible_tags_final.yml не найден."
  exit 1
fi

grep -q 'tags: \[packages\]' /root/ansible_tags_final.yml || exit 1
grep -q 'tags: \[deploy\]' /root/ansible_tags_final.yml || exit 1
exit 0
