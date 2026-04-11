#!/bin/bash
if [ ! -s /root/lsblk_report.txt ] || [ ! -s /root/mount_report.txt ]; then
  echo "Нужны непустые файлы /root/lsblk_report.txt и /root/mount_report.txt."
  exit 1
fi

grep -q "NAME" /root/lsblk_report.txt || exit 1
exit 0
