#!/bin/bash
if [ ! -f /root/inspect_image_info.txt ]; then
  echo "Файл /root/inspect_image_info.txt не найден."
  exit 1
fi

grep -q 'Image=nginx:alpine' /root/inspect_image_info.txt || exit 1
grep -q 'Cmd=' /root/inspect_image_info.txt || exit 1
exit 0
