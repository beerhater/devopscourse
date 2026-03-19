#!/bin/bash
kubectl get pvc final-pvc 2>/dev/null | grep -q 'Bound' && \
kubectl get deployment final-app 2>/dev/null | grep -q 'final-app'
