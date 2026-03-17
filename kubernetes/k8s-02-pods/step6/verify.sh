#!/bin/bash
kubectl get pod sidecar-demo 2>/dev/null | grep -q 'Running'
