#!/bin/bash
if iptables -L INPUT -n | grep -q "8080"; then
  exit 0
else
  echo "Правило для порта 8080 не найдено. Попробуйте: iptables -A INPUT -p tcp --dport 8080 -j ACCEPT"
  exit 1
fi
