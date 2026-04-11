#!/bin/bash
if [ ! -f /root/resource_describe_sections.txt ]; then
  echo "Файл /root/resource_describe_sections.txt не найден."
  exit 1
fi

grep -q 'Requests:' /root/resource_describe_sections.txt || exit 1
grep -q 'Limits:' /root/resource_describe_sections.txt || exit 1
exit 0
