#!/bin/bash
if [ ! -f /root/cleanup_before.txt ] || [ ! -f /root/cleanup_after.txt ] || [ ! -f /root/docker_prune_output.txt ]; then
  echo "Нужны файлы cleanup_before.txt, cleanup_after.txt и docker_prune_output.txt."
  exit 1
fi

grep -q '^cleanup-demo$' /root/cleanup_before.txt || exit 1
if grep -q 'cleanup-demo' /root/cleanup_after.txt; then
  echo "cleanup-demo всё ещё найден после удаления."
  exit 1
fi
exit 0
