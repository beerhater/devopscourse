#!/bin/bash
if [ -f "/root/upgrade_dry_run.txt" ]; then
  if grep -q "Inst " /root/upgrade_dry_run.txt || grep -q "0 upgraded" /root/upgrade_dry_run.txt; then
    exit 0
  else
    echo "Файл не похож на вывод apt upgrade -s."
    exit 1
  fi
else
  echo "Файл upgrade_dry_run.txt не найден. Попробуйте: apt upgrade -s > upgrade_dry_run.txt"
  exit 1
fi
