#!/bin/bash
if [ -f "/root/search_result.txt" ] && [ -f "/root/jq_info.txt" ]; then
  if grep -q "Package: jq" /root/jq_info.txt; then
    exit 0
  else
    echo "Файл jq_info.txt не содержит информацию о jq. Попробуйте: apt show jq > jq_info.txt"
    exit 1
  fi
else
  echo "Файлы search_result.txt или jq_info.txt не найдены."
  exit 1
fi
