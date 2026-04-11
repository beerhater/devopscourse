#!/bin/bash
if [ ! -f /root/cicd_artifacts_multi.yml ]; then
  echo "Файл /root/cicd_artifacts_multi.yml не найден."
  exit 1
fi

grep -q 'name: release-bundle' /root/cicd_artifacts_multi.yml || exit 1
grep -q 'dist/' /root/cicd_artifacts_multi.yml || exit 1
grep -q 'reports/' /root/cicd_artifacts_multi.yml || exit 1
exit 0
