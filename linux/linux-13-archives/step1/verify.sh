#!/bin/bash
if [ ! -f /root/project.tar ]; then
  echo "Архив /root/project.tar не найден."
  exit 1
fi

tar -tf /root/project.tar | grep -q "^project/config/app.env$" || exit 1
tar -tf /root/project.tar | grep -q "^project/logs/app.log$" || exit 1
tar -tf /root/project.tar | grep -q "^project/scripts/deploy.sh$" || exit 1
exit 0
