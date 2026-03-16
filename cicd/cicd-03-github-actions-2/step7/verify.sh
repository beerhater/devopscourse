#!/bin/bash
test -f /opt/final-docker-actions/.github/workflows/ci-cd.yml && python3 -c "import yaml; yaml.safe_load(open('/opt/final-docker-actions/.github/workflows/ci-cd.yml'))" 2>/dev/null && grep -q "matrix:" /opt/final-docker-actions/.github/workflows/ci-cd.yml && grep -q "cache-from:" /opt/final-docker-actions/.github/workflows/ci-cd.yml
