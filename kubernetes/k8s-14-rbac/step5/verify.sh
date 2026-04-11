#!/bin/bash
if [ ! -f /root/rbac_binding_details.txt ]; then
  echo "Файл /root/rbac_binding_details.txt не найден."
  exit 1
fi

grep -q '^viewer pod-reader$' /root/rbac_binding_details.txt || exit 1
exit 0
