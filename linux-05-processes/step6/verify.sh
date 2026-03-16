#!/bin/bash
if ! pgrep -x "sleep" > /dev/null; then
  exit 0
else
  echo "Процессы sleep ещё работают. Убейте все: pkill sleep"
  exit 1
fi
