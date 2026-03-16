#!/bin/bash
[ -x "/root/check_servers.sh" ] && grep -q "check_server" "/root/check_servers.sh" && exit 0 || exit 1
