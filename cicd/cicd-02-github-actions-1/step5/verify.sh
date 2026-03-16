#!/bin/bash
test -f /opt/gh-actions-demo/.github/workflows/env-demo.yml && grep -q "GITHUB_ENV" /opt/gh-actions-demo/.github/workflows/env-demo.yml
