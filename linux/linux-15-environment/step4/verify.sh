#!/bin/bash
if [ ! -f /root/deploy_report_path.txt ] || [ ! -f /root/deploy_report_output.txt ]; then
  echo "Нужны файлы /root/deploy_report_path.txt и /root/deploy_report_output.txt."
  exit 1
fi

grep -q "^/opt/env-lab/bin/deploy-report$" /root/deploy_report_path.txt || exit 1
grep -q "deploy-report is /opt/env-lab/bin/deploy-report" /root/deploy_report_type.txt || exit 1
grep -q "^release ok$" /root/deploy_report_output.txt || exit 1
exit 0
