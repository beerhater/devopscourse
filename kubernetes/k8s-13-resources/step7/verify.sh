#!/bin/bash
if [ ! -f /root/k8s_resource_recommendation.txt ]; then
  echo "Файл /root/k8s_resource_recommendation.txt не найден."
  exit 1
fi

grep -q '^requests=for_scheduling$' /root/k8s_resource_recommendation.txt || exit 1
grep -q '^guaranteed=when_requests_equal_limits$' /root/k8s_resource_recommendation.txt || exit 1
exit 0
