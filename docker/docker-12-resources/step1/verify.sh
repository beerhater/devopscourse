#!/bin/bash
if [ ! -f /root/resource_limits.txt ] || [ ! -f /root/resource_status.txt ]; then
  echo "Нужны файлы resource_limits.txt и resource_status.txt."
  exit 1
fi

grep -q 'Memory=134217728' /root/resource_limits.txt || exit 1
grep -q 'NanoCpus=500000000' /root/resource_limits.txt || exit 1
grep -q 'resource-demo' /root/resource_status.txt || exit 1
exit 0
