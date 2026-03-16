#!/bin/bash
test -f /opt/docker-actions-demo/.github/workflows/docker-build-push.yml && docker ps | grep -q "local-registry"
