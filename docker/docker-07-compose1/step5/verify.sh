#!/bin/bash
set -e
cd /opt/compose-intro
if docker compose version >/dev/null 2>&1; then
  docker compose ps --services 2>/dev/null | grep -q '^db$'
else
  docker-compose ps --services 2>/dev/null | grep -q '^db$'
fi
