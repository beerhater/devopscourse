#!/bin/bash
kubectl get namespace development 2>/dev/null | grep -q 'development'
