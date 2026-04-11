#!/bin/bash
if [ ! -f /root/big_files.txt ]; then
  echo "Файл /root/big_files.txt не найден."
  exit 1
fi

grep -q "/opt/diagnostics-lab/backups/db.dump" /root/big_files.txt || exit 1
grep -q "/opt/diagnostics-lab/images/cache.tar" /root/big_files.txt || exit 1
exit 0
