#!/bin/bash
if [ ! -f /root/reusable_secrets_inherit.yml ]; then
  echo "Файл /root/reusable_secrets_inherit.yml не найден."
  exit 1
fi

grep -q 'secrets: inherit' /root/reusable_secrets_inherit.yml || exit 1
exit 0
