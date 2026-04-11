#!/bin/bash
if [ ! -f /root/inspect_final_report.txt ]; then
  echo "Файл /root/inspect_final_report.txt не найден."
  exit 1
fi

grep -q '^container=inspect-demo$' /root/inspect_final_report.txt || exit 1
grep -q '^image=nginx:alpine$' /root/inspect_final_report.txt || exit 1
grep -q '^http_ok=yes$' /root/inspect_final_report.txt || exit 1
exit 0
