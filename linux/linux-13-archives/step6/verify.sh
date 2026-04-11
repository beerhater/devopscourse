#!/bin/bash
if [ ! -f /root/config-snapshot.tar.xz ] || [ ! -f /root/config_snapshot_list.txt ]; then
  echo "Нужны файлы /root/config-snapshot.tar.xz и /root/config_snapshot_list.txt."
  exit 1
fi

grep -q "^project/config/app.env$" /root/config_snapshot_list.txt || exit 1
exit 0
