#!/bin/bash
if [ ! -f /root/one_run_env.txt ]; then
  echo "Файл /root/one_run_env.txt не найден."
  exit 1
fi

grep -q "^prod$" /root/one_run_env.txt || exit 1
exit 0
