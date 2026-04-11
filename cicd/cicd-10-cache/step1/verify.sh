#!/bin/bash
if [ ! -f /root/cicd_cache_result.yml ]; then
  echo "Файл /root/cicd_cache_result.yml не найден."
  exit 1
fi

grep -q 'actions/cache@v4' /root/cicd_cache_result.yml || exit 1
grep -q 'path: ~/.npm' /root/cicd_cache_result.yml || exit 1
grep -q 'hashFiles' /root/cicd_cache_result.yml || exit 1
exit 0
