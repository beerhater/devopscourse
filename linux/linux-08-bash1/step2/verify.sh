#!/bin/bash
[ -x "/root/vars.sh" ] && grep -q "USER=" "/root/vars.sh" && exit 0 || exit 1
