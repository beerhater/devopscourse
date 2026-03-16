#!/bin/bash
if [ -f "/root/curl_code.txt" ]; then
  code=$(cat /root/curl_code.txt)
  if [ "$code" = "200" ]; then
    exit 0
  else
    echo "HTTP код неверный (получили: $code, ожидали: 200)"
    exit 1
  fi
else
  echo "Файл curl_code.txt не найден. Попробуйте: curl -s -o /dev/null -w \"%{http_code}\" https://httpbin.org/get > curl_code.txt"
  exit 1
fi
