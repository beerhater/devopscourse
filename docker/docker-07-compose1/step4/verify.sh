#!/bin/bash
set -e
cd /opt/compose-intro
if docker compose version >/dev/null 2>&1; then
  docker compose ps --status running --services 2>/dev/null | grep -q .
else
  docker-compose ps --services 2>/dev/null | grep -q .
fi
