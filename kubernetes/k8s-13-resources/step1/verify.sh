#!/bin/bash
if [ ! -f /root/resource_pod_describe.txt ] || [ ! -f /root/resource_values.txt ]; then
  echo "Нужны файлы resource_pod_describe.txt и resource_values.txt."
  exit 1
fi

kubectl get pod resource-demo >/dev/null 2>&1 || exit 1
grep -q 'Requests:' /root/resource_pod_describe.txt || exit 1
grep -q 'Limits:' /root/resource_pod_describe.txt || exit 1
grep -q '^100m 128Mi$' /root/resource_values.txt || exit 1
exit 0
