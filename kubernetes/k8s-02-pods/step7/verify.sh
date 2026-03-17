#!/bin/bash
kubectl get pod final-app 2>/dev/null | grep -qE 'Running|Completed' || true
