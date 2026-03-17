#!/bin/bash
kubectl get deployment safe-app 2>/dev/null | grep -q '3/3'
