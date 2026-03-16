#!/bin/bash
if [ -x "/root/myscript.sh" ]; then
  exit 0
else
  echo "Файл myscript.sh не является исполняемым. Попробуйте: chmod +x myscript.sh"
  exit 1
fi
