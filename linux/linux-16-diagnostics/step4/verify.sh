#!/bin/bash
if [ ! -f /root/du_report.txt ]; then
  echo "Файл /root/du_report.txt не найден."
  exit 1
fi

grep -q "/opt/diagnostics-lab/logs" /root/du_report.txt || exit 1
grep -q "/opt/diagnostics-lab/backups" /root/du_report.txt || exit 1
grep -q "/opt/diagnostics-lab/images" /root/du_report.txt || exit 1
exit 0
