#!/bin/bash
[ -x "/root/func_return.sh" ] && grep -q "\$(" "/root/func_return.sh" && exit 0 || exit 1
