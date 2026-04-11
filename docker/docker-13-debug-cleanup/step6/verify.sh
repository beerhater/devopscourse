#!/bin/bash
if [ ! -f /root/cleanup_volume_after.txt ]; then
  echo "Файл /root/cleanup_volume_after.txt не найден."
  exit 1
fi

if [ -s /root/cleanup_volume_after.txt ]; then
  echo "cleanup-vol всё ещё присутствует."
  exit 1
fi
exit 0
