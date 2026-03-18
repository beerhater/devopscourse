#!/bin/bash
kubectl get secret registry-creds 2>/dev/null | grep -q 'registry-creds'
