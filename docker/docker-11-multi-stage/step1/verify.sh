#!/bin/bash
if [ ! -f /root/multistage_workdir.txt ] || [ ! -f /root/multistage_release.txt ] || [ ! -f /root/multistage_copy_from.txt ]; then
  echo "Нужны файлы multistage_workdir.txt, multistage_release.txt и multistage_copy_from.txt."
  exit 1
fi

grep -q '^/app$' /root/multistage_workdir.txt || exit 1
grep -q 'platform release 2026-04' /root/multistage_release.txt || exit 1
grep -q 'COPY --from=builder' /root/multistage_copy_from.txt || exit 1
exit 0
