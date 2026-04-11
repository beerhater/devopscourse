#!/bin/bash
if [ ! -f /root/restart_policy_recommendation.txt ]; then
  echo "Файл /root/restart_policy_recommendation.txt не найден."
  exit 1
fi

grep -q '^service=unless-stopped$' /root/restart_policy_recommendation.txt || exit 1
grep -q '^crashing_worker=on-failure$' /root/restart_policy_recommendation.txt || exit 1
grep -q '^no_policy=manual_control$' /root/restart_policy_recommendation.txt || exit 1
exit 0
