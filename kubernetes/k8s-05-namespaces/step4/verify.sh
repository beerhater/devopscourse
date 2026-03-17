#!/bin/bash
kubectl get deployment my-app -n development 2>/dev/null | grep -q 'my-app'
