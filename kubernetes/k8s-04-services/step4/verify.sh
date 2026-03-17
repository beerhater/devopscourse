#!/bin/bash
kubectl get service demo-nodeport 2>/dev/null | grep -q 'NodePort'
