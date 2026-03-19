#!/bin/bash
kubectl get pvc postgres-data 2>/dev/null | grep -q 'Bound'
