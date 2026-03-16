#!/bin/bash
if getent group sudo | grep -q "deploy"; then
  exit 0
else
  echo "Пользователь deploy не состоит в группе sudo. Попробуйте: usermod -aG sudo deploy"
  exit 1
fi
