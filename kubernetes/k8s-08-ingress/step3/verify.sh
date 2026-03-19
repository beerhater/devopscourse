#!/bin/bash
kubectl get ingress basic-ingress 2>/dev/null | grep -q 'basic-ingress'
