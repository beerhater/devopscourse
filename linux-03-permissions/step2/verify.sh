#!/bin/bash
perms=$(stat -c "%a" /root/myfile.txt 2>/dev/null)
if [ "$perms" = "600" ]; then
  exit 0
else
  echo "Права на myfile.txt неверные (сейчас: $perms). Попробуйте: chmod 600 myfile.txt"
  exit 1
fi
