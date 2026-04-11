#!/bin/bash
if [ ! -f /root/cicd_step_env.yml ]; then
  echo "Файл /root/cicd_step_env.yml не найден."
  exit 1
fi

grep -q 'RELEASE_COLOR: green' /root/cicd_step_env.yml || exit 1
exit 0
