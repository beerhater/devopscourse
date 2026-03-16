#!/bin/bash
test -f /opt/docker-actions-demo/Dockerfile && test -f /opt/docker-actions-demo/.github/workflows/docker-build.yml && docker images | grep -q "docker-actions-demo"
