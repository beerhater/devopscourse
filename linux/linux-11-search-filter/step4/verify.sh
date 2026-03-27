#!/bin/bash
if [ ! -f /root/conf_files.txt ] || [ ! -f /root/archive_dirs.txt ]; then
  echo "Файлы с результатами find не найдены."
  exit 1
fi

grep -q "/opt/search-lab/configs/api/app.conf" /root/conf_files.txt || exit 1
grep -q "/opt/search-lab/configs/archive/legacy.conf" /root/conf_files.txt || exit 1
grep -q "/opt/search-lab/configs/archive" /root/archive_dirs.txt || exit 1
exit 0
