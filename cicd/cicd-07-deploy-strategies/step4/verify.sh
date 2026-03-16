#!/bin/bash
test -f /opt/deploy-demo/canary-deploy.sh && grep -q 'weight' /opt/deploy-demo/canary-deploy.sh
