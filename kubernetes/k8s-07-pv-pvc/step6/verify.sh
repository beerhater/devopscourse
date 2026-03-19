#!/bin/bash
kubectl get pv pv-retain-demo 2>/dev/null | grep -qE 'Available|Released'
