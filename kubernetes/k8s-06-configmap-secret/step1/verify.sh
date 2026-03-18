#!/bin/bash
kubectl get configmap app-config 2>/dev/null | grep -q 'app-config'
