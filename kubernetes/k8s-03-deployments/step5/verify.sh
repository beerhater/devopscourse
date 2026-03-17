#!/bin/bash
kubectl rollout history deployment/web-app 2>/dev/null | grep -q 'deployment.apps/web-app'
