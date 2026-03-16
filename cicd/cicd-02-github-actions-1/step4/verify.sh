#!/bin/bash
test -f /opt/gh-actions-demo/.github/workflows/multi-job.yml && grep -q "needs:" /opt/gh-actions-demo/.github/workflows/multi-job.yml
