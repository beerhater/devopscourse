#!/bin/bash
test -f /opt/gh-actions-demo/.github/workflows/ci.yml && grep -q "pull_request" /opt/gh-actions-demo/.github/workflows/ci.yml
