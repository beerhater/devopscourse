#!/bin/bash
if [ ! -f /root/stateful_pods.txt ] || [ ! -f /root/stateful_service_type.txt ]; then
  echo "Нужны файлы stateful_pods.txt и stateful_service_type.txt."
  exit 1
fi

kubectl get statefulset app-stateful >/dev/null 2>&1 || exit 1
grep -q 'pod/app-stateful-0' /root/stateful_pods.txt || exit 1
grep -q 'pod/app-stateful-1' /root/stateful_pods.txt || exit 1
grep -q '^None$' /root/stateful_service_type.txt || exit 1
exit 0
