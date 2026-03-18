#!/bin/bash
kubectl get configmap app-version-config 2>/dev/null | grep -q 'app-version-config'
