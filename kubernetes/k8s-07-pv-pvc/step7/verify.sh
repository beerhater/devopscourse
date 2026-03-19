#!/bin/bash
kubectl get storageclass 2>/dev/null | grep -qv '^NAME'
