#!/bin/bash
if [ ! -f /root/inspect_http.txt ]; then
  echo "Файл /root/inspect_http.txt не найден."
  exit 1
fi

grep -qi 'nginx' /root/inspect_http.txt || exit 1
exit 0
