#!/bin/bash
# Проверяем очищен ли кэш
archives_count=$(ls -1 /var/cache/apt/archives/*.deb 2>/dev/null | wc -l)
if [ "$archives_count" -eq "0" ]; then
  exit 0
else
  echo "Кэш apt не пуст. Запустите: apt clean"
  exit 1
fi
