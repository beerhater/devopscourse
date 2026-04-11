#!/bin/bash
if [ ! -f /root/guaranteed_qos.txt ]; then
  echo "Файл /root/guaranteed_qos.txt не найден."
  exit 1
fi

kubectl get pod guaranteed-demo >/dev/null 2>&1 || exit 1
grep -q '^Guaranteed$' /root/guaranteed_qos.txt || exit 1
exit 0
