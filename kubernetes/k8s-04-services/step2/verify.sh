#!/bin/bash
kubectl get service demo-svc 2>/dev/null | grep -q 'ClusterIP'
