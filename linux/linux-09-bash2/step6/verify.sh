#!/bin/bash
[ -f "/root/script.log" ] && [ -s "/root/script.log" ] && exit 0 || exit 1
