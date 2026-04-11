#!/bin/bash
if [ ! -f /root/project-backup.tar.gz ]; then
  echo "Архив /root/project-backup.tar.gz не найден."
  exit 1
fi

tar -tzf /root/project-backup.tar.gz | grep -q "^project/scripts/deploy.sh$" || exit 1
tar -tzf /root/project-backup.tar.gz | grep -q "^project/logs/app.log$" || exit 1
exit 0
