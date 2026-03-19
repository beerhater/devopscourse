#!/bin/bash
kubectl get secret myapp-tls 2>/dev/null | grep -q 'kubernetes.io/tls'
