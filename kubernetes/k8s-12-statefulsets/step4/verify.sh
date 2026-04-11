#!/bin/bash
if [ ! -f /root/stateful_service_details.txt ]; then
  echo "Файл /root/stateful_service_details.txt не найден."
  exit 1
fi

grep -q '^None app-headless$' /root/stateful_service_details.txt || exit 1
exit 0
