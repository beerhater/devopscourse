#!/bin/bash
if [ ! -f /root/rbac_can_get.txt ] || [ ! -f /root/rbac_can_delete.txt ] || [ ! -f /root/rbac_binding.txt ]; then
  echo "Нужны файлы rbac_can_get.txt, rbac_can_delete.txt и rbac_binding.txt."
  exit 1
fi

kubectl get sa viewer >/dev/null 2>&1 || exit 1
grep -q '^yes$' /root/rbac_can_get.txt || exit 1
grep -q '^no$' /root/rbac_can_delete.txt || exit 1
grep -q 'pod-reader-binding' /root/rbac_binding.txt || exit 1
exit 0
