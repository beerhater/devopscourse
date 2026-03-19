#!/bin/bash
kubectl get pvc pvc-demo 2>/dev/null | grep -q 'Bound'
