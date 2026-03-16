#!/bin/bash
test -f /opt/gh-actions-demo/.github/workflows/hello.yml && python3 -c "import yaml; yaml.safe_load(open('/opt/gh-actions-demo/.github/workflows/hello.yml'))" 2>/dev/null
