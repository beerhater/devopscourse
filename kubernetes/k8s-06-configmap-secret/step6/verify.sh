#!/bin/bash
kubectl get deployment nginx-configured 2>/dev/null | grep -q '2/2'
