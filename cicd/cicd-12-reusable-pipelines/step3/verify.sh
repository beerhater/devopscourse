#!/bin/bash
if [ ! -f /root/reusable_outputs.yml ]; then
  echo "Файл /root/reusable_outputs.yml не найден."
  exit 1
fi

grep -q 'outputs:' /root/reusable_outputs.yml || exit 1
grep -q 'image-tag:' /root/reusable_outputs.yml || exit 1
exit 0
