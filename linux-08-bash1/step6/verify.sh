#!/bin/bash
[ -d "/root/logs" ] && grep -q "\-d" "/root/check_file.sh" && exit 0 || exit 1
