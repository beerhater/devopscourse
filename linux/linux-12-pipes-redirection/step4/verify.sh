#!/bin/bash
if [ ! -f /root/ls_ok.txt ] || [ ! -f /root/ls_errors.txt ]; then
  echo "Нужны файлы /root/ls_ok.txt и /root/ls_errors.txt."
  exit 1
fi

grep -q "/etc/passwd" /root/ls_ok.txt || exit 1
grep -q "/etc/hosts" /root/ls_ok.txt || exit 1
grep -q "absent.cfg" /root/ls_errors.txt || exit 1
exit 0
