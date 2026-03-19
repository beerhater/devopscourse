#!/bin/bash
kubectl get ingress final-ingress 2>/dev/null | grep -q 'final-ingress' && \
kubectl get secret final-tls-secret 2>/dev/null | grep -q 'kubernetes.io/tls'
