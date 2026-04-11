#!/bin/bash
if [ ! -f /root/course_profile.txt ]; then
  echo "Файл /root/course_profile.txt не найден."
  exit 1
fi

grep -q "^export COURSE_PROFILE=linux-devops$" /root/.bashrc || exit 1
grep -q "^linux-devops$" /root/course_profile.txt || exit 1
exit 0
