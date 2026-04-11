#!/bin/bash
if [ ! -f /root/ansible_rescue_result.txt ] || [ ! -f /root/ansible_always_result.txt ]; then
  echo "Нужны файлы ansible_rescue_result.txt и ansible_always_result.txt."
  exit 1
fi

grep -q '^rescue executed$' /root/ansible_rescue_result.txt || exit 1
grep -q '^always executed$' /root/ansible_always_result.txt || exit 1
exit 0
