#!/bin/bash
if [ ! -f /root/incident_location.txt ]; then
  echo "Файл /root/incident_location.txt не найден."
  exit 1
fi

grep -q "/opt/search-lab/services/api/current.log:3:ERROR Connection refused to db.internal" /root/incident_location.txt || exit 1
exit 0
