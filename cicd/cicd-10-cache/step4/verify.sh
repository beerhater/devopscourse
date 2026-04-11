#!/bin/bash
if [ ! -f /root/cicd_cache_setup_node.yml ]; then
  echo "Файл /root/cicd_cache_setup_node.yml не найден."
  exit 1
fi

grep -q 'cache: npm' /root/cicd_cache_setup_node.yml || exit 1
exit 0
