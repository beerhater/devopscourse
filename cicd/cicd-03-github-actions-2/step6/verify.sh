#!/bin/bash
test -f /opt/docker-actions-demo/.github/workflows/full-pipeline.yml && grep -q "matrix:" /opt/docker-actions-demo/.github/workflows/full-pipeline.yml && grep -q "cache-from:" /opt/docker-actions-demo/.github/workflows/full-pipeline.yml
