#!/bin/bash
set -e
test -f /opt/prod-stack/docker-compose.yml
test -f /opt/prod-stack/nginx.conf
grep -q "healthcheck" /opt/prod-stack/docker-compose.yml
grep -q "proxy_pass http://app_backend;" /opt/prod-stack/nginx.conf
