#!/bin/bash
if [ ! -f /root/inspect_demo_report.txt ] || [ ! -f /root/inspect_demo_logs.txt ] || [ ! -f /root/inspect_demo_exec.txt ]; then
  echo "Нужны файлы inspect_demo_report.txt, inspect_demo_logs.txt и inspect_demo_exec.txt."
  exit 1
fi

grep -q 'nginx:alpine' /root/inspect_demo_report.txt || exit 1
grep -q '80' /root/inspect_demo_report.txt || exit 1
grep -q 'nginx version:' /root/inspect_demo_exec.txt || exit 1
grep -q 'config-ok' /root/inspect_demo_exec.txt || exit 1
exit 0
