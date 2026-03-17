#!/bin/bash
kubectl exec my-nginx -- nginx -v 2>&1 | grep -q 'nginx'
