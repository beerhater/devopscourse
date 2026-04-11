#!/bin/bash
if [ ! -f /root/restore-basic/project/config/app.env ]; then
  echo "Файл app.env не найден после распаковки."
  exit 1
fi

grep -q "^APP_NAME=platform-api$" /root/restore-basic/project/config/app.env || exit 1
grep -q "^APP_ENV=staging$" /root/restore-basic/project/config/app.env || exit 1
exit 0
