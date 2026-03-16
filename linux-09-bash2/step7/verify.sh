#!/bin/bash
[ -f "/root/cron.log" ] && [ -s "/root/cron.log" ] && exit 0 || exit 1
