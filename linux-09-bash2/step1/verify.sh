#!/bin/bash
[ -x "/root/args.sh" ] && grep -q "\$1" "/root/args.sh" && exit 0 || exit 1
