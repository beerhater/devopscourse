#!/bin/bash
kubectl get pv pv-hostpath-1 2>/dev/null | grep -qE 'Available|Bound'
