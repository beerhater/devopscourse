#!/bin/bash
kubectl get deployment final-probes-app 2>/dev/null | grep -q 'final-probes-app'
