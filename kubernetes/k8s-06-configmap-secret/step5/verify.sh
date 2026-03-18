#!/bin/bash
kubectl get configmap live-config 2>/dev/null | grep -q 'live-config'
