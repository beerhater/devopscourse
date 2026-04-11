#!/bin/bash
if [ ! -f /root/k8s_troubleshooting_checklist.txt ]; then
  echo "Файл /root/k8s_troubleshooting_checklist.txt не найден."
  exit 1
fi

grep -q '^1_check_describe=yes$' /root/k8s_troubleshooting_checklist.txt || exit 1
grep -q '^3_check_logs=yes$' /root/k8s_troubleshooting_checklist.txt || exit 1
exit 0
