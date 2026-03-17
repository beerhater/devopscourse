#!/bin/bash
kubectl get deployment web-app -o jsonpath='{.spec.strategy.type}' | grep -q 'RollingUpdate'
