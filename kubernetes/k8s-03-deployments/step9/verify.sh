#!/bin/bash
kubectl rollout history deployment/final-web 2>/dev/null | grep -q 'deployment.apps' || kubectl get deployments 2>/dev/null | grep -v NAME | wc -l | grep -qv '^0$'
