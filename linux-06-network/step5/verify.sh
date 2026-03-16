#!/bin/bash
if dpkg -l | grep -q "net-tools"; then
  exit 0
else
  echo "Пакет net-tools не установлен. Попробуйте: apt-get install -y net-tools"
  exit 1
fi
