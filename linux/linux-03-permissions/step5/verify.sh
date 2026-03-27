#!/bin/bash
group=$(stat -c "%G" /root/shared.txt 2>/dev/null)
if [ "$group" = "developers" ]; then
  exit 0
else
  echo "Группа файла shared.txt не developers (сейчас: $group). Попробуйте: chgrp developers shared.txt"
  exit 1
fi
