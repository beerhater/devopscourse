#!/bin/bash
if [ ! -f /root/cicd_matrix_os.yml ]; then
  echo "Файл /root/cicd_matrix_os.yml не найден."
  exit 1
fi

grep -q 'os: \[ubuntu-latest, macos-latest\]' /root/cicd_matrix_os.yml || exit 1
exit 0
