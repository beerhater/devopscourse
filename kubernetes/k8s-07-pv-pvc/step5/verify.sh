#!/bin/bash
kubectl get pvc pvc-rwo 2>/dev/null | grep -q 'Bound'
