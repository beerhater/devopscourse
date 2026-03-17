#!/bin/bash
kubectl get deployment my-nginx -o jsonpath='{.spec.replicas}' | grep -qE '[2-9]|[1-9][0-9]'
