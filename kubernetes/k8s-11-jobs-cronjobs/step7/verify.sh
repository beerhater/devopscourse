#!/bin/bash
if [ ! -f /root/jobs_cronjobs_report.txt ]; then
  echo "Файл /root/jobs_cronjobs_report.txt не найден."
  exit 1
fi

grep -q '^job=one_off_task$' /root/jobs_cronjobs_report.txt || exit 1
grep -q '^cronjob=scheduled_task$' /root/jobs_cronjobs_report.txt || exit 1
exit 0
