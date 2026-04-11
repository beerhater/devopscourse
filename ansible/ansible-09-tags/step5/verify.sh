#!/bin/bash
if [ ! -f /root/ansible_deploy_config.txt ] || [ ! -f /root/ansible_deploy_only.txt ]; then
  echo "Нужны файлы ansible_deploy_config.txt и ansible_deploy_only.txt."
  exit 1
fi

grep -q '^absent$' /root/ansible_deploy_config.txt || exit 1
grep -q '^present$' /root/ansible_deploy_only.txt || exit 1
exit 0
