#!/bin/bash
kubectl get networkpolicy -n development 2>/dev/null | grep -q 'allow-same-namespace'
