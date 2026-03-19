#!/bin/bash
kubectl get ingress host-ingress 2>/dev/null | grep -q 'host-ingress'
