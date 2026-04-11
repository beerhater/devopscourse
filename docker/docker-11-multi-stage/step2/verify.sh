#!/bin/bash
if [ ! -f /root/multistage_builder_image.txt ]; then
  echo "Файл /root/multistage_builder_image.txt не найден."
  exit 1
fi

grep -q '^multistage-builder:v1$' /root/multistage_builder_image.txt || exit 1
exit 0
