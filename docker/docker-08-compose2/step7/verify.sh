#!/bin/bash
test -f /opt/prod-stack/docker-compose.yml && grep -q "healthcheck" /opt/prod-stack/docker-compose.yml
