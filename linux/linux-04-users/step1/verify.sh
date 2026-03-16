#!/bin/bash
if id "deploy" &>/dev/null; then
  if [ -d "/home/deploy" ]; then
    exit 0
  else
    echo "Пользователь deploy существует, но домашняя директория не создана. Попробуйте: useradd -m -s /bin/bash deploy"
    exit 1
  fi
else
  echo "Пользователь deploy не найден. Попробуйте: useradd -m -s /bin/bash deploy"
  exit 1
fi
