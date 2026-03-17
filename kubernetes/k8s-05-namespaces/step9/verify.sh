#!/bin/bash
kubectl get namespace final-dev 2>/dev/null | grep -q 'final-dev' && kubectl get deployment api -n final-dev 2>/dev/null | grep -q 'api'
