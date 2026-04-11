#!/bin/bash
if [ ! -f /root/broken_events.txt ]; then
  echo "Файл /root/broken_events.txt не найден."
  exit 1
fi

grep -Eq 'ErrImagePull|ImagePullBackOff|Failed to pull image' /root/broken_events.txt || exit 1
exit 0
