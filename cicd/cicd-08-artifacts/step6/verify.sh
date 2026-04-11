#!/bin/bash
if [ ! -f /root/cicd_artifacts_final.yml ]; then
  echo "Файл /root/cicd_artifacts_final.yml не найден."
  exit 1
fi

grep -q 'name: release-bundle' /root/cicd_artifacts_final.yml || exit 1
grep -q 'retention-days: 7' /root/cicd_artifacts_final.yml || exit 1
grep -q 'reports/' /root/cicd_artifacts_final.yml || exit 1
exit 0
