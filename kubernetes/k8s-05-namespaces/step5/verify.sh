#!/bin/bash
kubectl get resourcequota -n development 2>/dev/null | grep -q 'dev-quota'
