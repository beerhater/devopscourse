#!/bin/bash
if [ ! -f /root/cicd_artifacts_result.yml ]; then
  echo "Файл /root/cicd_artifacts_result.yml не найден."
  exit 1
fi

grep -q 'actions/upload-artifact@v4' /root/cicd_artifacts_result.yml || exit 1
grep -q 'name: release-files' /root/cicd_artifacts_result.yml || exit 1
grep -q 'path: dist/' /root/cicd_artifacts_result.yml || exit 1
exit 0
