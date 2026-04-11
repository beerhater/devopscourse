#!/bin/bash
if [ ! -f /root/app.log.gz ] || [ ! -f /root/app.log.restored ]; then
  echo "Нужны файлы /root/app.log.gz и /root/app.log.restored."
  exit 1
fi

grep -q "ERROR db timeout" /root/app.log.restored || exit 1
exit 0
