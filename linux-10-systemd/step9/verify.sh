#!/bin/bash
[ -f "/root/myapp_restart.log" ] && systemctl is-active myapp &>/dev/null && exit 0 || exit 1
