#!/bin/bash
if [ ! -f /root/inspect_ports.txt ]; then
  echo "Файл /root/inspect_ports.txt не найден."
  exit 1
fi

grep -q '0.0.0.0:8091' /root/inspect_ports.txt || grep -q ':8091' /root/inspect_ports.txt || exit 1
exit 0
