#!/bin/bash
kubectl get secret db-credentials 2>/dev/null | grep -q 'db-credentials'
