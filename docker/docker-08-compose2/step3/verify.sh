#!/bin/bash
grep -q "healthcheck" /root/prodstack/docker-compose.yml && exit 0 || exit 1
