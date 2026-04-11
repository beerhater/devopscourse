#!/bin/bash
if [ ! -f /root/recovered_app.env ]; then
  echo "Файл /root/recovered_app.env не найден."
  exit 1
fi

grep -q "^APP_NAME=platform-api$" /root/recovered_app.env || exit 1
grep -q "^APP_PORT=8080$" /root/recovered_app.env || exit 1
exit 0
