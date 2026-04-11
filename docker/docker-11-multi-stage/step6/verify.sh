#!/bin/bash
if [ ! -f /root/multistage_release_v2.txt ]; then
  echo "Файл /root/multistage_release_v2.txt не найден."
  exit 1
fi

grep -q 'platform release 2026-05' /root/multistage_release_v2.txt || exit 1
exit 0
