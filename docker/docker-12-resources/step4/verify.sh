#!/bin/bash
if [ ! -f /root/resource_nofile_limit.txt ]; then
  echo "Файл /root/resource_nofile_limit.txt не найден."
  exit 1
fi

grep -q '"Name":"nofile"' /root/resource_nofile_limit.txt || exit 1
grep -q '"Soft":1024' /root/resource_nofile_limit.txt || exit 1
exit 0
