#!/bin/bash
kubectl get ingress app-ingress 2>/dev/null | grep -q 'app-ingress'
