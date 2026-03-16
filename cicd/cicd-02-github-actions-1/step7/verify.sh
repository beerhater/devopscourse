#!/bin/bash
test -f /opt/final-gha/.github/workflows/ci.yml && python3 -c "import yaml; yaml.safe_load(open('/opt/final-gha/.github/workflows/ci.yml'))" 2>/dev/null && grep -q "needs:" /opt/final-gha/.github/workflows/ci.yml
