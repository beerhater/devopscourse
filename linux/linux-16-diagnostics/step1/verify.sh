#!/bin/bash
if [ ! -f /root/system_uname.txt ] || [ ! -f /root/system_uptime.txt ] || [ ! -f /root/system_cpus.txt ]; then
  echo "Нужны файлы system_uname.txt, system_uptime.txt и system_cpus.txt."
  exit 1
fi

grep -q "Linux" /root/system_uname.txt || exit 1
grep -Eq "^[0-9]+$" /root/system_cpus.txt || exit 1
exit 0
