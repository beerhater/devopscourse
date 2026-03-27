#!/bin/bash
if [ ! -f /root/db_host_hits.txt ]; then
  echo "Файл /root/db_host_hits.txt не найден."
  exit 1
fi

grep -q "/opt/search-lab/configs/app.env:DB_HOST=db.internal" /root/db_host_hits.txt || exit 1
grep -q "/opt/search-lab/configs/api/config.yml:  DB_HOST: db.internal" /root/db_host_hits.txt || exit 1
exit 0
