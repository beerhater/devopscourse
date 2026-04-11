#!/bin/bash
if [ ! -f /root/stateful_scaled_pods.txt ]; then
  echo "Файл /root/stateful_scaled_pods.txt не найден."
  exit 1
fi

grep -q 'pod/app-stateful-2' /root/stateful_scaled_pods.txt || exit 1
exit 0
