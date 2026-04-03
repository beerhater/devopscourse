#!/bin/bash
set -e
kubectl get pod final-app 2>/dev/null | grep -q 'Running'
kubectl get pod final-app -o jsonpath='{.metadata.labels.app}' 2>/dev/null | grep -q '^final$'
kubectl get pod final-app -o jsonpath='{.metadata.labels.env}' 2>/dev/null | grep -q '^practice$'
kubectl get pod final-app -o jsonpath='{.spec.initContainers[0].name}' 2>/dev/null | grep -q '^init-check$'
kubectl get pod final-app -o jsonpath='{.spec.containers[*].name}' 2>/dev/null | grep -q 'sidecar'
kubectl get pods -l app=final --no-headers 2>/dev/null | grep -q 'final-app'
kubectl get pods -l env=practice --no-headers 2>/dev/null | grep -q 'final-app'
