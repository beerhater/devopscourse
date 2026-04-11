#!/bin/bash
if [ ! -f /root/cicd_artifacts_reports.yml ]; then
  echo "Файл /root/cicd_artifacts_reports.yml не найден."
  exit 1
fi

grep -q 'name: junit-report' /root/cicd_artifacts_reports.yml || exit 1
grep -q 'reports/junit.xml' /root/cicd_artifacts_reports.yml || exit 1
exit 0
