#!/bin/bash
if [ ! -f /root/cicd_artifacts_checklist.txt ]; then
  echo "Файл /root/cicd_artifacts_checklist.txt не найден."
  exit 1
fi

grep -q '^save_build_outputs=yes$' /root/cicd_artifacts_checklist.txt || exit 1
grep -q '^download_between_jobs=yes$' /root/cicd_artifacts_checklist.txt || exit 1
exit 0
