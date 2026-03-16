#!/bin/bash
test -f /opt/deploy-demo/bg-deploy.sh && grep -q 'rollback' /opt/deploy-demo/bg-deploy.sh
