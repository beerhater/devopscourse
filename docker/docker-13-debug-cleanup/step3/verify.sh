#!/bin/bash
if [ ! -f /root/cleanup_network_before.txt ]; then
  echo "Файл /root/cleanup_network_before.txt не найден."
  exit 1
fi

grep -q '^cleanup-net$' /root/cleanup_network_before.txt || exit 1
exit 0
