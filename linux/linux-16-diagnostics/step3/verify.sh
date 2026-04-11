#!/bin/bash
if [ ! -f /root/root_fs_df.txt ] || [ ! -f /root/root_fs_inodes.txt ]; then
  echo "Нужны файлы /root/root_fs_df.txt и /root/root_fs_inodes.txt."
  exit 1
fi

grep -q " /$" /root/root_fs_df.txt || grep -q " / " /root/root_fs_df.txt || exit 1
grep -q " /$" /root/root_fs_inodes.txt || grep -q " / " /root/root_fs_inodes.txt || exit 1
exit 0
