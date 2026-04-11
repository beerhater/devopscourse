#!/bin/bash
if [ ! -f /root/cicd_matrix_include.yml ]; then
  echo "Файл /root/cicd_matrix_include.yml не найден."
  exit 1
fi

grep -q 'include:' /root/cicd_matrix_include.yml || exit 1
grep -q 'node: 22' /root/cicd_matrix_include.yml || exit 1
exit 0
