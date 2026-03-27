#!/bin/bash
if [ ! -f /root/stdout.log ] || [ ! -f /root/stderr.log ]; then
  echo "Нужны файлы /root/stdout.log и /root/stderr.log."
  exit 1
fi

grep -q "/etc/passwd" /root/stdout.log || exit 1
grep -q "missing-file" /root/stderr.log || exit 1
exit 0
