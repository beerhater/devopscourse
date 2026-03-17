#!/bin/bash
kubectl get pod web-pod 2>/dev/null | grep -qE 'Running|ContainerCreating'
