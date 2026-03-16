#!/bin/bash
if getent group developers | grep -q "deploy"; then
  exit 0
else
  echo "Пользователь deploy не состоит в группе developers. Попробуйте: usermod -aG developers deploy"
  exit 1
fi
