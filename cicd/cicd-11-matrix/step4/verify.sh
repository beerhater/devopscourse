#!/bin/bash
if [ ! -f /root/cicd_matrix_exclude.yml ]; then
  echo "Файл /root/cicd_matrix_exclude.yml не найден."
  exit 1
fi

grep -q 'exclude:' /root/cicd_matrix_exclude.yml || exit 1
grep -q 'windows-latest' /root/cicd_matrix_exclude.yml || exit 1
exit 0
