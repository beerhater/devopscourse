#!/bin/bash
if [ -f "/root/ip_info.txt" ] && [ -s "/root/ip_info.txt" ]; then
  exit 0
else
  echo "Файл ip_info.txt не найден или пустой. Попробуйте: ip addr show | grep \"inet \" | grep -v \"127.0.0.1\" > ip_info.txt"
  exit 1
fi
