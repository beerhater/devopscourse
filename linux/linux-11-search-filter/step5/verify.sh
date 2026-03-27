#!/bin/bash
if [ ! -f /root/ip_count.txt ] || [ ! -f /root/ip_stats.txt ]; then
  echo "Нужны файлы /root/ip_count.txt и /root/ip_stats.txt."
  exit 1
fi

grep -q "8 /opt/search-lab/ip-list.txt" /root/ip_count.txt || exit 1
grep -Eq "^[[:space:]]*3 10.0.0.5$" /root/ip_stats.txt || exit 1
exit 0
