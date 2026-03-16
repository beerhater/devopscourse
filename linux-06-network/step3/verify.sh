#!/bin/bash
if [ -f "/root/robots.txt" ] && [ -s "/root/robots.txt" ]; then
  exit 0
else
  echo "Файл robots.txt не найден или пустой. Попробуйте: wget -O robots.txt https://www.google.com/robots.txt"
  exit 1
fi
