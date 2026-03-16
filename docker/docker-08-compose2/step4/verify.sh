#!/bin/bash
cd /root/prodstack && docker compose ps | grep -qi "running\|up" && exit 0 || exit 1
