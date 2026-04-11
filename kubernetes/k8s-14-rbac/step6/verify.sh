#!/bin/bash
if [ ! -f /root/rbac_serviceaccount.yaml ]; then
  echo "Файл /root/rbac_serviceaccount.yaml не найден."
  exit 1
fi

grep -q 'name: viewer' /root/rbac_serviceaccount.yaml || exit 1
grep -q 'kind: ServiceAccount' /root/rbac_serviceaccount.yaml || exit 1
exit 0
