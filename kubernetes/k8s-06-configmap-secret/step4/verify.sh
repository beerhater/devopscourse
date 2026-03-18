#!/bin/bash
kubectl get pod app-volume-demo 2>/dev/null | grep -q 'Running'
