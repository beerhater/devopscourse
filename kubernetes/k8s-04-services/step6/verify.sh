#!/bin/bash
kubectl get endpoints demo-svc 2>/dev/null | grep -q 'demo-svc'
