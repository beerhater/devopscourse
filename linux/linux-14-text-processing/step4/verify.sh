#!/bin/bash
if [ ! -f /root/service_memory.txt ] || [ ! -f /root/total_cpu.txt ]; then
  echo "Нужны файлы /root/service_memory.txt и /root/total_cpu.txt."
  exit 1
fi

grep -q "^api 256$" /root/service_memory.txt || exit 1
grep -q "^worker 512$" /root/service_memory.txt || exit 1
grep -q "^600$" /root/total_cpu.txt || exit 1
exit 0
