#!/bin/bash
if [ ! -f /root/memory_report.txt ] || [ ! -f /root/memory_report_mb.txt ]; then
  echo "Нужны файлы /root/memory_report.txt и /root/memory_report_mb.txt."
  exit 1
fi

grep -q "^Mem:" /root/memory_report.txt || exit 1
grep -q "^Mem:" /root/memory_report_mb.txt || exit 1
exit 0
