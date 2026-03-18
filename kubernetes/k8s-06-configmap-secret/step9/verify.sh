#!/bin/bash
kubectl get deployment final-app 2>/dev/null | grep -q '2/2' && kubectl get secret final-app-secret 2>/dev/null | grep -q 'final-app-secret'
