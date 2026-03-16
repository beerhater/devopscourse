#!/bin/bash
if [ -f "/root/jq_path.txt" ] && [ -f "/root/tree_status.txt" ]; then
  if grep -q "tree" /root/tree_status.txt; then
    exit 0
  else
    echo "В файле tree_status.txt не найдено слово tree."
    exit 1
  fi
else
  echo "Файлы jq_path.txt или tree_status.txt не найдены."
  exit 1
fi
