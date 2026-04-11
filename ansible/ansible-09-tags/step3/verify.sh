#!/bin/bash
if [ ! -f /root/ansible_skip_config.txt ] || [ ! -f /root/ansible_skip_deploy.txt ]; then
  echo "Нужны файлы ansible_skip_config.txt и ansible_skip_deploy.txt."
  exit 1
fi

grep -q '^present$' /root/ansible_skip_config.txt || exit 1
grep -q '^absent$' /root/ansible_skip_deploy.txt || exit 1
exit 0
