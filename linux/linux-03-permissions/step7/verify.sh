#!/bin/bash
perms=$(stat -c "%a" /shared-dropbox 2>/dev/null)
if [ "$perms" = "1777" ] && [ -f "/shared-dropbox/readme.txt" ]; then
  exit 0
else
  echo "Для /shared-dropbox ожидаются права 1777 и файл readme.txt. Проверьте: mkdir -p /shared-dropbox && chmod 1777 /shared-dropbox"
  exit 1
fi
