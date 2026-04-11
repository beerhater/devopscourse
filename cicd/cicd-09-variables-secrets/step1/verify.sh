#!/bin/bash
if [ ! -f /root/cicd_vars_result.yml ]; then
  echo "Файл /root/cicd_vars_result.yml не найден."
  exit 1
fi

grep -q 'APP_ENV: production' /root/cicd_vars_result.yml || exit 1
grep -q 'APP_PORT: "8080"' /root/cicd_vars_result.yml || exit 1
grep -q '\${{ secrets.REGISTRY_PASSWORD }}' /root/cicd_vars_result.yml || exit 1
exit 0
