#!/bin/bash
[ -f /root/prodstack/docker-compose.yml ] && grep -q "depends_on" /root/prodstack/docker-compose.yml && exit 0 || exit 1
