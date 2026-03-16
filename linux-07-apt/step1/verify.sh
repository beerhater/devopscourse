#!/bin/bash
# Проверяем что apt update был запущен недавно (файлы в lists обновились)
if find /var/lib/apt/lists -type f -mmin -60 | grep -q "Packages"; then
  exit 0
else
  echo "Списки пакетов не обновлены. Запустите: apt update"
  exit 1
fi
