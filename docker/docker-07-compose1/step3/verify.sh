#!/bin/bash
cd /root/mystack && docker compose ps | grep -qi "running\|up" && exit 0 || exit 1
