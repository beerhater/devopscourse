#!/bin/bash
if [ ! -f /root/rbac_configmaps_after.txt ]; then
  echo "Файл /root/rbac_configmaps_after.txt не найден."
  exit 1
fi

grep -q '^yes$' /root/rbac_configmaps_after.txt || exit 1
exit 0
