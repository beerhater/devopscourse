#!/bin/bash
if [ ! -f /root/stateful_ordinals.txt ]; then
  echo "Файл /root/stateful_ordinals.txt не найден."
  exit 1
fi

grep -q '^app-stateful-0$' /root/stateful_ordinals.txt || exit 1
grep -q '^app-stateful-1$' /root/stateful_ordinals.txt || exit 1
grep -q '^app-stateful-2$' /root/stateful_ordinals.txt || exit 1
exit 0
