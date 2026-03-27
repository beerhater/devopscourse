#!/bin/bash
if [ ! -f /root/deploy_notes.log ]; then
  echo "Файл /root/deploy_notes.log не найден."
  exit 1
fi

lines=$(wc -l < /root/deploy_notes.log)
grep -q "config validated" /root/deploy_notes.log || exit 1

if [ "$lines" = "3" ]; then
  exit 0
else
  echo "В /root/deploy_notes.log должно быть 3 строки, сейчас: $lines"
  exit 1
fi
