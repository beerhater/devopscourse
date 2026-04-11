#!/bin/bash
if [ ! -f /root/rbac_role.yaml ]; then
  echo "Файл /root/rbac_role.yaml не найден."
  exit 1
fi

grep -q 'name: pod-reader' /root/rbac_role.yaml || exit 1
grep -q 'resources:' /root/rbac_role.yaml || exit 1
exit 0
