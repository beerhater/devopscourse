#!/bin/bash
if [ ! -f /root/broken_reason_jsonpath.txt ]; then
  echo "Файл /root/broken_reason_jsonpath.txt не найден."
  exit 1
fi

grep -Eq 'ErrImagePull|ImagePullBackOff' /root/broken_reason_jsonpath.txt || exit 1
exit 0
