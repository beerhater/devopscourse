#!/bin/bash
if dpkg -l | grep -q "^ii.*ncdu"; then
  echo "Пакет ncdu всё ещё установлен. Попробуйте: apt purge -y ncdu"
  exit 1
else
  exit 0
fi
