#!/bin/bash
kubectl get pod app-envfrom-demo 2>/dev/null | grep -qE 'Running|Completed' || kubectl get configmap app-config 2>/dev/null | grep -q 'app-config'
