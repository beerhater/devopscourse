#!/bin/bash
if [ ! -f /root/jobs_status.txt ] || [ ! -f /root/cronjobs_status.txt ]; then
  echo "Нужны файлы jobs_status.txt и cronjobs_status.txt."
  exit 1
fi

kubectl get job report-job >/dev/null 2>&1 || exit 1
kubectl get cronjob report-cron >/dev/null 2>&1 || exit 1
grep -q 'report-job' /root/jobs_status.txt || exit 1
grep -q 'report-cron' /root/cronjobs_status.txt || exit 1
exit 0
