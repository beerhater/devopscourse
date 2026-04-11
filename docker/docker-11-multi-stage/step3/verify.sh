#!/bin/bash
if [ ! -f /root/multistage_runtime_files.txt ]; then
  echo "Файл /root/multistage_runtime_files.txt не найден."
  exit 1
fi

grep -q '^release.txt$' /root/multistage_runtime_files.txt || exit 1
exit 0
