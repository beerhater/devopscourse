#!/bin/bash
kubectl get deployment my-nginx 2>/dev/null | grep -q 'my-nginx'
