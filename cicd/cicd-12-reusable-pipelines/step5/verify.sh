#!/bin/bash
if [ ! -f /root/reusable_caller_params.yml ]; then
  echo "Файл /root/reusable_caller_params.yml не найден."
  exit 1
fi

grep -q 'app-name: payments-api' /root/reusable_caller_params.yml || exit 1
grep -q 'deploy-env: production' /root/reusable_caller_params.yml || exit 1
exit 0
