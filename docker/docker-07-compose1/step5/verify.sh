#!/bin/bash
cd /root/mystack && docker compose ps | grep -qi "running\|up" && exit 1 || exit 0
