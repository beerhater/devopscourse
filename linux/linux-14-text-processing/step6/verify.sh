#!/bin/bash
if [ ! -f /root/prod_images_report.txt ]; then
  echo "Файл /root/prod_images_report.txt не найден."
  exit 1
fi

grep -q "^api -> nginx:1.27$" /root/prod_images_report.txt || exit 1
grep -q "^cron -> alpine:3.20$" /root/prod_images_report.txt || exit 1
exit 0
