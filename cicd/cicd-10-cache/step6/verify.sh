#!/bin/bash
if [ ! -f /root/cicd_cache_final.yml ]; then
  echo "Файл /root/cicd_cache_final.yml не найден."
  exit 1
fi

grep -q 'cache: npm' /root/cicd_cache_final.yml || exit 1
grep -q 'actions/cache@v4' /root/cicd_cache_final.yml || exit 1
grep -q 'restore-keys:' /root/cicd_cache_final.yml || exit 1
exit 0
