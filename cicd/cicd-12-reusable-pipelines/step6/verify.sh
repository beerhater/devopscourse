#!/bin/bash
if [ ! -f /root/reusable_final.yml ]; then
  echo "Файл /root/reusable_final.yml не найден."
  exit 1
fi

grep -q 'uses: \./\.github/workflows/common-test.yml' /root/reusable_final.yml || exit 1
grep -q 'secrets: inherit' /root/reusable_final.yml || exit 1
exit 0
