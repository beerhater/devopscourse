#!/bin/bash
if [ ! -f /root/rbac_report.txt ]; then
  echo "Файл /root/rbac_report.txt не найден."
  exit 1
fi

grep -q '^viewer_can_delete_pods=no$' /root/rbac_report.txt || exit 1
grep -q '^principle=least_privilege$' /root/rbac_report.txt || exit 1
exit 0
