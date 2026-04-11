#!/bin/bash
if [ ! -f /root/app_name_env.txt ]; then
  echo "Файл /root/app_name_env.txt не найден."
  exit 1
fi

grep -q "^platform-api$" /root/app_name_env.txt || exit 1
exit 0
