#!/bin/bash
if which jq >/dev/null && which tree >/dev/null && which ncdu >/dev/null; then
  exit 0
else
  echo "Не все пакеты установлены. Попробуйте: apt install -y jq tree ncdu"
  exit 1
fi
