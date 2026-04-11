#!/bin/bash
if [ ! -f /root/stateful_report.txt ]; then
  echo "Файл /root/stateful_report.txt не найден."
  exit 1
fi

grep -q '^stable_names=yes$' /root/stateful_report.txt || exit 1
grep -q '^use_case=databases_and_clustered_apps$' /root/stateful_report.txt || exit 1
exit 0
