#!/bin/bash
if [ ! -f /root/cicd_cache_compare.txt ]; then
  echo "Файл /root/cicd_cache_compare.txt не найден."
  exit 1
fi

grep -q '^actions_cache=flexible_custom_paths$' /root/cicd_cache_compare.txt || exit 1
grep -q '^setup_node_cache=simple_for_npm$' /root/cicd_cache_compare.txt || exit 1
exit 0
