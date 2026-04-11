#!/bin/bash
if [ ! -f /root/cicd_artifacts_retention.yml ]; then
  echo "Файл /root/cicd_artifacts_retention.yml не найден."
  exit 1
fi

grep -q 'retention-days: 7' /root/cicd_artifacts_retention.yml || exit 1
exit 0
