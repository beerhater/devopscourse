#!/bin/bash
kubectl get ingress rate-limit-ingress 2>/dev/null | grep -q 'rate-limit-ingress'
