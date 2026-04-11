#!/bin/bash
if [ ! -f /root/cicd_artifacts_download.yml ]; then
  echo "Файл /root/cicd_artifacts_download.yml не найден."
  exit 1
fi

grep -q 'actions/download-artifact@v4' /root/cicd_artifacts_download.yml || exit 1
grep -q 'name: release-files' /root/cicd_artifacts_download.yml || exit 1
exit 0
