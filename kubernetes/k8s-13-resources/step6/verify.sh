#!/bin/bash
if [ ! -f /root/k8s_resource_report.txt ]; then
  echo "Файл /root/k8s_resource_report.txt не найден."
  exit 1
fi

grep -q '^resource-demo 100m 128Mi$' /root/k8s_resource_report.txt || exit 1
grep -q '^guaranteed-demo 100m 64Mi$' /root/k8s_resource_report.txt || exit 1
exit 0
