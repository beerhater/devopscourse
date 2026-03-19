#!/bin/bash
kubectl get pods -n ingress-nginx 2>/dev/null | grep -q 'controller'
