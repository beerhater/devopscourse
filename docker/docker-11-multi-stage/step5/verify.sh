#!/bin/bash
if [ ! -f /root/multistage_dockerignore.txt ]; then
  echo "Файл /root/multistage_dockerignore.txt не найден."
  exit 1
fi

grep -q '^\*\.log$' /root/multistage_dockerignore.txt || exit 1
grep -q '^tmp/$' /root/multistage_dockerignore.txt || exit 1
exit 0
