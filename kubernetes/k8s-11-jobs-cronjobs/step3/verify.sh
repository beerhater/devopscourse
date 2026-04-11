#!/bin/bash
if [ ! -f /root/manual_job_status.txt ]; then
  echo "Файл /root/manual_job_status.txt не найден."
  exit 1
fi

kubectl get job report-manual >/dev/null 2>&1 || exit 1
grep -q 'report-manual' /root/manual_job_status.txt || exit 1
exit 0
