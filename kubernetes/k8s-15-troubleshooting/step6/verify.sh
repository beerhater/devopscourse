#!/bin/bash
if [ ! -f /root/troubleshooting_compare.txt ]; then
  echo "Файл /root/troubleshooting_compare.txt не найден."
  exit 1
fi

grep -q '^broken-demo ' /root/troubleshooting_compare.txt || exit 1
grep -q '^crash-demo CrashLoopBackOff$' /root/troubleshooting_compare.txt || exit 1
exit 0
