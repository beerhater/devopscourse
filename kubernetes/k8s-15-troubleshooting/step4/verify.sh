#!/bin/bash
if [ ! -f /root/crash_reason.txt ]; then
  echo "Файл /root/crash_reason.txt не найден."
  exit 1
fi

kubectl get pod crash-demo >/dev/null 2>&1 || exit 1
grep -q 'CrashLoopBackOff' /root/crash_reason.txt || exit 1
exit 0
