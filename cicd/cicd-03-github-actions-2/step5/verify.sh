#!/bin/bash
test -f /opt/docker-actions-demo/.github/workflows/matrix.yml && grep -q "matrix:" /opt/docker-actions-demo/.github/workflows/matrix.yml
