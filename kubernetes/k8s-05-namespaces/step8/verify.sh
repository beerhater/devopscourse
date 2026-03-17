#!/bin/bash
kubectl get namespace app-dev 2>/dev/null | grep -q 'app-dev'
