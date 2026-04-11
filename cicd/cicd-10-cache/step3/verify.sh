#!/bin/bash
if [ ! -f /root/cicd_cache_python.yml ]; then
  echo "Файл /root/cicd_cache_python.yml не найден."
  exit 1
fi

grep -q '~/.cache/pip' /root/cicd_cache_python.yml || exit 1
grep -q 'requirements.txt' /root/cicd_cache_python.yml || exit 1
exit 0
