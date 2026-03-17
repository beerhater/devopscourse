#!/bin/bash
kubectl get deployment demo-app 2>/dev/null | grep -q 'demo-app'
