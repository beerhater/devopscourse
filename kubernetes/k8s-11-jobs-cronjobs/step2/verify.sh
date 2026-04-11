#!/bin/bash
if [ ! -f /root/job_report_logs.txt ]; then
  echo "Файл /root/job_report_logs.txt не найден."
  exit 1
fi

grep -q 'report-ready' /root/job_report_logs.txt || exit 1
exit 0
