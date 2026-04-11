#!/bin/bash
if [ ! -f /root/user_roles.txt ]; then
  echo "Файл /root/user_roles.txt не найден."
  exit 1
fi

grep -q "^name,role$" /root/user_roles.txt || exit 1
grep -q "^anna,devops$" /root/user_roles.txt || exit 1
grep -q "^irina,sre$" /root/user_roles.txt || exit 1
exit 0
