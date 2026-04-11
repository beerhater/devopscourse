#!/bin/bash
if [ ! -f /root/reusable_inputs.yml ]; then
  echo "Файл /root/reusable_inputs.yml не найден."
  exit 1
fi

grep -q 'deploy-env:' /root/reusable_inputs.yml || exit 1
exit 0
