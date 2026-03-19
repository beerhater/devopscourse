#!/bin/bash
kubectl get deployment readiness-demo 2>/dev/null | grep -q 'readiness-demo'
