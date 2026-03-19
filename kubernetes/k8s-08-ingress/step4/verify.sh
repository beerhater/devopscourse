#!/bin/bash
kubectl get ingress path-ingress 2>/dev/null | grep -q 'path-ingress'
