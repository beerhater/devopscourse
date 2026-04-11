#!/bin/bash
if [ ! -f /root/multistage_final_report.txt ]; then
  echo "Файл /root/multistage_final_report.txt не найден."
  exit 1
fi

grep -q '^builder=multistage-builder:v1$' /root/multistage_final_report.txt || exit 1
grep -q 'runtime_file=platform release 2026-04' /root/multistage_final_report.txt || exit 1
grep -q 'runtime_file_v2=platform release 2026-05' /root/multistage_final_report.txt || exit 1
exit 0
