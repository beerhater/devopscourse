#!/bin/bash
if [ ! -f /root/cicd_matrix_parallel.yml ]; then
  echo "Файл /root/cicd_matrix_parallel.yml не найден."
  exit 1
fi

grep -q 'fail-fast: false' /root/cicd_matrix_parallel.yml || exit 1
grep -q 'max-parallel: 2' /root/cicd_matrix_parallel.yml || exit 1
exit 0
