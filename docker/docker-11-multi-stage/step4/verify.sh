#!/bin/bash
if [ ! -f /root/multistage_history.txt ]; then
  echo "Файл /root/multistage_history.txt не найден."
  exit 1
fi

grep -qi 'release.txt' /root/multistage_history.txt || grep -qi 'COPY --from=builder' /root/multistage_copy_from.txt || exit 1
exit 0
