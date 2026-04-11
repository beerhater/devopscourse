#!/bin/bash
if [ ! -f /root/broken_pod_describe.txt ] || [ ! -f /root/broken_reason.txt ]; then
  echo "Нужны файлы broken_pod_describe.txt и broken_reason.txt."
  exit 1
fi

kubectl get pod broken-demo >/dev/null 2>&1 || exit 1
grep -Eq 'ErrImagePull|ImagePullBackOff|Failed to pull image' /root/broken_reason.txt || exit 1
exit 0
