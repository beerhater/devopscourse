#!/bin/bash
if [ ! -f /root/reusable_common.yml ] || [ ! -f /root/reusable_caller.yml ]; then
  echo "Нужны файлы reusable_common.yml и reusable_caller.yml."
  exit 1
fi

grep -q 'workflow_call:' /root/reusable_common.yml || exit 1
grep -q 'uses: \./\.github/workflows/common-test.yml' /root/reusable_caller.yml || exit 1
grep -q 'app-name: payments-api' /root/reusable_caller.yml || exit 1
exit 0
