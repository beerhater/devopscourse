#!/bin/bash
test -f /opt/final-deploy/.gitlab-ci.yml && test -f /opt/final-deploy/smoke-test.sh && docker images final-app:v1 --format '{{.Tag}}' | grep -q 'v1'
