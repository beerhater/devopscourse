#!/bin/bash
# Проверяем что пользователь deploy существует и имеет рабочий shell
if [ -f "/home/deploy/.bash_history" ] || [ -d "/home/deploy" ]; then
  exit 0
else
  echo "Попробуйте переключиться: su - deploy, затем вернитесь: exit"
  exit 1
fi
