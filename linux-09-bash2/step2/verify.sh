#!/bin/bash
[ -x "/root/deploy.sh" ] && grep -q "\-z" "/root/deploy.sh" && exit 0 || exit 1
