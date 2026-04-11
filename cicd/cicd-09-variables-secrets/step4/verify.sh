#!/bin/bash
if [ ! -f /root/cicd_github_env.yml ]; then
  echo "Файл /root/cicd_github_env.yml не найден."
  exit 1
fi

grep -q '\$GITHUB_ENV' /root/cicd_github_env.yml || exit 1
grep -q 'IMAGE_TAG=build-42' /root/cicd_github_env.yml || exit 1
exit 0
