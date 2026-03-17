#!/bin/bash
kubectl get service frontend-svc 2>/dev/null | grep -q 'NodePort' && kubectl get service backend-svc 2>/dev/null | grep -q 'ClusterIP'
