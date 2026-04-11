#!/bin/bash
if [ ! -f /root/cicd_matrix_result.yml ]; then
  echo "Файл /root/cicd_matrix_result.yml не найден."
  exit 1
fi

grep -q 'matrix:' /root/cicd_matrix_result.yml || exit 1
grep -q 'node: \[18, 20\]' /root/cicd_matrix_result.yml || exit 1
grep -q '\${{ matrix.node }}' /root/cicd_matrix_result.yml || exit 1
exit 0
