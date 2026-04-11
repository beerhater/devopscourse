#!/bin/bash
if [ ! -f /root/inspect_startup_logs.txt ]; then
  echo "Файл /root/inspect_startup_logs.txt не найден."
  exit 1
fi

grep -Eqi 'start worker process|nginx|Configuration complete' /root/inspect_startup_logs.txt || exit 1
exit 0
