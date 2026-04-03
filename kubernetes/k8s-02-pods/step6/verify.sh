#!/bin/bash
set -e
kubectl get pod sidecar-demo 2>/dev/null | grep -q 'Running'
kubectl get pod init-demo 2>/dev/null | grep -q 'Running'
kubectl logs sidecar-demo -c log-reader 2>/dev/null | grep -q 'running'
kubectl logs init-demo -c wait-for-setup 2>/dev/null | grep -q 'Init: done!'
