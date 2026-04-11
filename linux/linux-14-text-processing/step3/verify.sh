#!/bin/bash
if [ ! -f /root/app-prod.env ]; then
  echo "Файл /root/app-prod.env не найден."
  exit 1
fi

grep -q "^APP_ENV=prod$" /root/app-prod.env || exit 1
grep -q "^APP_PORT=8080$" /root/app-prod.env || exit 1
exit 0
