#!/bin/bash
if [ ! -f /root/cicd_job_env.yml ]; then
  echo "Файл /root/cicd_job_env.yml не найден."
  exit 1
fi

grep -q 'env:' /root/cicd_job_env.yml || exit 1
grep -q 'APP_ENV: production' /root/cicd_job_env.yml || exit 1
exit 0
