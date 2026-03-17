#!/bin/bash
kubectl get deployment web-app 2>/dev/null | grep -q '3/3'
