#!/bin/bash
[ -f /root/finalstack/docker-compose.yml ] && [ -f /root/finalstack/.env ] && exit 0 || exit 1
