#!/bin/bash
if [ ! -f /root/cicd_matrix_final.yml ]; then
  echo "Файл /root/cicd_matrix_final.yml не найден."
  exit 1
fi

grep -q 'runs-on: \${{ matrix.os }}' /root/cicd_matrix_final.yml || exit 1
grep -q 'fail-fast: false' /root/cicd_matrix_final.yml || exit 1
grep -q 'node-version: \${{ matrix.node }}' /root/cicd_matrix_final.yml || exit 1
exit 0
