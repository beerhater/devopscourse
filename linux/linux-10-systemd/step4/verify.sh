#!/bin/bash
[ -f "/root/nginx.log" ] && [ -s "/root/nginx.log" ] && exit 0 || exit 1
