#!/bin/bash
if [ ! -f /root/cicd_secret_split.yml ]; then
  echo "Файл /root/cicd_secret_split.yml не найден."
  exit 1
fi

grep -q 'REGISTRY_USER: deploy-bot' /root/cicd_secret_split.yml || exit 1
grep -q '\${{ secrets.REGISTRY_PASSWORD }}' /root/cicd_secret_split.yml || exit 1
exit 0
