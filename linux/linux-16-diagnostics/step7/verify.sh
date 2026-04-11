#!/bin/bash
if [ ! -f /root/largest_file.txt ]; then
  echo "Файл /root/largest_file.txt не найден."
  exit 1
fi

grep -q "/opt/diagnostics-lab/images/cache.tar" /root/largest_file.txt || exit 1
exit 0
