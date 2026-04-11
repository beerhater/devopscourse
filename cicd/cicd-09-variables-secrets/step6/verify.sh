#!/bin/bash
if [ ! -f /root/cicd_vars_secure.yml ]; then
  echo "Файл /root/cicd_vars_secure.yml не найден."
  exit 1
fi

grep -q 'IMAGE_TAG=release-42' /root/cicd_vars_secure.yml || exit 1
grep -q '\${{ secrets.REGISTRY_PASSWORD }}' /root/cicd_vars_secure.yml || exit 1
exit 0
