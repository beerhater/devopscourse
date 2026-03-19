#!/bin/bash
kubectl get deployment frontend 2>/dev/null | grep -q 'frontend'
