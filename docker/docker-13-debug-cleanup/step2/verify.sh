#!/bin/bash
if [ ! -f /root/docker_system_df.txt ]; then
  echo "Файл /root/docker_system_df.txt не найден."
  exit 1
fi

grep -q 'TYPE' /root/docker_system_df.txt || exit 1
exit 0
