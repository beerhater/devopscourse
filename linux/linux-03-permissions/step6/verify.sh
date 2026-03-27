#!/bin/bash
perms=$(stat -c "%a" /root/secure-by-default.txt 2>/dev/null)
if [ "$perms" = "640" ]; then
  exit 0
else
  echo "Ожидались права 640 для secure-by-default.txt, сейчас: $perms. Проверьте: umask 027 && touch secure-by-default.txt"
  exit 1
fi
