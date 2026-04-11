#!/bin/bash
if [ ! -f /root/stateful_scaled_back.txt ]; then
  echo "Файл /root/stateful_scaled_back.txt не найден."
  exit 1
fi

grep -q 'pod/app-stateful-0' /root/stateful_scaled_back.txt || exit 1
grep -q 'pod/app-stateful-1' /root/stateful_scaled_back.txt || exit 1
if grep -q 'pod/app-stateful-2' /root/stateful_scaled_back.txt; then
  echo "Третья реплика всё ещё присутствует."
  exit 1
fi
exit 0
