#!/bin/bash
test -f /tmp/final-modules/production/prometheus.yml &&
cd ~/tf-final-modules && terraform state list 2>/dev/null | grep 'module\.' | grep -q '.'
