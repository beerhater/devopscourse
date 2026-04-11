#!/bin/bash
if [ ! -f /root/project_tar_list.txt ]; then
  echo "Файл /root/project_tar_list.txt не найден."
  exit 1
fi

grep -q "^project/config/app.env$" /root/project_tar_list.txt || exit 1
grep -q "^project/scripts/deploy.sh$" /root/project_tar_list.txt || exit 1
exit 0
