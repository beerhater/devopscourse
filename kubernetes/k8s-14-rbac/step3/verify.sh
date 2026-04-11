#!/bin/bash
if [ ! -f /root/rbac_configmaps_before.txt ]; then
  echo "Файл /root/rbac_configmaps_before.txt не найден."
  exit 1
fi

grep -q '^no$' /root/rbac_configmaps_before.txt || exit 1
exit 0
