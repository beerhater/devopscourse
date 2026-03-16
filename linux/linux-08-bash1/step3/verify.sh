#!/bin/bash
grep -q "\$(" "/root/cmd.sh" && exit 0 || exit 1
