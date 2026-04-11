#!/bin/bash
if [ ! -f /root/resource_limits_detailed.txt ]; then
  echo "Файл /root/resource_limits_detailed.txt не найден."
  exit 1
fi

grep -q 'memory=134217728' /root/resource_limits_detailed.txt || exit 1
grep -q 'nanocpus=500000000' /root/resource_limits_detailed.txt || exit 1
exit 0
