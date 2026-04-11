#!/bin/bash
if [ ! -f /root/cleanup_network_after.txt ]; then
  echo "Файл /root/cleanup_network_after.txt не найден."
  exit 1
fi

if [ -s /root/cleanup_network_after.txt ]; then
  echo "cleanup-net всё ещё присутствует."
  exit 1
fi
exit 0
