#!/bin/bash
owner=$(stat -c "%U" /root/devopsfile.txt 2>/dev/null)
if [ "$owner" = "devops" ]; then
  exit 0
else
  echo "Владелец файла devopsfile.txt не devops (сейчас: $owner). Попробуйте: chown devops:devops devopsfile.txt"
  exit 1
fi
