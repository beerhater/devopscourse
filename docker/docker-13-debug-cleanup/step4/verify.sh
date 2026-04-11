#!/bin/bash
if [ ! -f /root/cleanup_volume_before.txt ]; then
  echo "Файл /root/cleanup_volume_before.txt не найден."
  exit 1
fi

grep -q '^cleanup-vol$' /root/cleanup_volume_before.txt || exit 1
exit 0
