#!/bin/bash
if [ ! -f /root/cicd_matrix_artifacts.yml ]; then
  echo "Файл /root/cicd_matrix_artifacts.yml не найден."
  exit 1
fi

grep -q 'build-\${{ matrix.node }}' /root/cicd_matrix_artifacts.yml || exit 1
exit 0
