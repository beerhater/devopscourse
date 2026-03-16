#!/bin/bash
if [ -f "/root/devops_project/readme.txt" ]; then
  exit 0
else
  echo "Файл readme.txt не найден внутри devops_project."
  exit 1
fi
