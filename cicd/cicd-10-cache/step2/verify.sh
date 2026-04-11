#!/bin/bash
if [ ! -f /root/cicd_cache_restore.yml ]; then
  echo "Файл /root/cicd_cache_restore.yml не найден."
  exit 1
fi

grep -q 'restore-keys:' /root/cicd_cache_restore.yml || exit 1
exit 0
