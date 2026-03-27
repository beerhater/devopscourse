#!/bin/bash
if [ ! -f /root/error_lines.txt ] || [ ! -f /root/timeout_lines.txt ]; then
  echo "Нужны файлы /root/error_lines.txt и /root/timeout_lines.txt."
  exit 1
fi

grep -q "ERROR Failed to reach payment API" /root/error_lines.txt || exit 1
grep -qi "Timeout while waiting for response" /root/timeout_lines.txt || exit 1
exit 0
