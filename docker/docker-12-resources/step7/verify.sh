#!/bin/bash
if [ ! -f /root/resource_recommendation.txt ]; then
  echo "Файл /root/resource_recommendation.txt не найден."
  exit 1
fi

grep -q '^memory_limit=protect_host_from_oom$' /root/resource_recommendation.txt || exit 1
grep -q '^cpu_limit=avoid_noisy_neighbor$' /root/resource_recommendation.txt || exit 1
grep -q '^pids_limit=protect_from_fork_bombs$' /root/resource_recommendation.txt || exit 1
exit 0
